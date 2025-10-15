<?php
header('Content-Type: application/json; charset=utf-8');
require __DIR__ . '/db.php';

$q      = isset($_GET['q'])    ? trim($_GET['q'])    : '';
$city   = isset($_GET['city']) ? trim($_GET['city']) : '';
$lang   = isset($_GET['lang']) ? trim($_GET['lang']) : '';   // фильтр рабочих языков спеца: hy|ru|en (из поля languages)
$gender = isset($_GET['gender']) ? trim($_GET['gender']) : ''; // 'female'|'male'|'nb'
$tlang  = isset($_GET['tlang'])? trim($_GET['tlang']): 'en'; // язык вывода/поиска: ru|en|hy
// Диапазоны цены и стажа, приходят как строки вида "15000-25000" или "40000+" / "10+"
$priceRange = isset($_GET['priceRange']) ? trim($_GET['priceRange']) : '';
$expRange   = isset($_GET['experienceRange']) ? trim($_GET['experienceRange']) : '';
$active = 1;

// на всякий случай фиксируем сравнения в utf8mb4
$mysqli->set_charset('utf8mb4');
$mysqli->query("SET NAMES utf8mb4 COLLATE utf8mb4_unicode_520_ci");

$sql = "SELECT
          s.id,
          COALESCE(t.name, s.name)           AS name,
          COALESCE(t.specialty, s.specialty) AS specialty,
          COALESCE(t.city_label, s.city)     AS city,
          t.slug,
     s.languages, s.gender, s.experience, s.price_from, s.rating,
          s.picture, s.contacts
        FROM specialists s
        LEFT JOIN specialist_translations t
               ON t.specialist_id = s.id AND t.lang = ?
        WHERE s.is_active = ?";

$params = [$tlang, $active];
$types  = "si";

if ($city !== '') {
  $sql .= " AND s.city = ?";
  $params[] = $city; $types .= "s";
}

if ($lang !== '') {
  // фильтр по рабочему языку специалиста (CSV в поле s.languages)
  $sql .= " AND FIND_IN_SET(?, REPLACE(s.languages, ' ', '')) > 0";
  $params[] = $lang; $types .= "s";
}

if ($gender !== '') {
  // безопасный фильтр по полу
  $sql .= " AND s.gender = ?";
  $params[] = $gender; $types .= "s";
}

// Фильтр по цене: ожидаем значения вида "a-b" или "a+"
if ($priceRange !== '') {
  $min = 0; $max = null;
  if (preg_match('/^(\d+)-(\d+)$/', $priceRange, $m)) {
    $min = (int)$m[1]; $max = (int)$m[2];
  } elseif (preg_match('/^(\d+)\+$/', $priceRange, $m)) {
    $min = (int)$m[1]; $max = null;
  } elseif (preg_match('/^(\d+)$/', $priceRange, $m)) {
    $min = (int)$m[1]; $max = null;
  }
  // price_from может быть NULL, поэтому при фильтре исключаем NULL
  $sql .= " AND s.price_from IS NOT NULL AND s.price_from >= ?";
  $params[] = $min; $types .= "i";
  if ($max !== null) { $sql .= " AND s.price_from <= ?"; $params[] = $max; $types .= "i"; }
}

// Фильтр по стажу: значения вида "a-b" или "a+"
if ($expRange !== '') {
  $emin = 0; $emax = null;
  if (preg_match('/^(\d+)-(\d+)$/', $expRange, $m)) {
    $emin = (int)$m[1]; $emax = (int)$m[2];
  } elseif (preg_match('/^(\d+)\+$/', $expRange, $m)) {
    $emin = (int)$m[1]; $emax = null;
  } elseif (preg_match('/^(\d+)$/', $expRange, $m)) {
    $emin = (int)$m[1]; $emax = null;
  }
  $sql .= " AND s.experience >= ?"; $params[] = $emin; $types .= "i";
  if ($emax !== null) { $sql .= " AND s.experience <= ?"; $params[] = $emax; $types .= "i"; }
}

if ($q !== '') {
  $needle = mb_strtolower($q, 'UTF-8');

  if (mb_strlen($q, 'UTF-8') >= 3) {
    // Длинные запросы: пробуем FULLTEXT по переводу выбранного языка + безопасный LIKE-фолбэк
    $sql .= " AND (
      (t.lang = ? AND MATCH(t.name, t.specialty, t.bio) AGAINST (? IN NATURAL LANGUAGE MODE))
      OR LOWER(COALESCE(t.name, s.name)) LIKE CONCAT('%', ?, '%')
      OR LOWER(COALESCE(t.specialty, s.specialty)) LIKE CONCAT('%', ?, '%')
      OR LOWER(COALESCE(t.bio, s.bio)) LIKE CONCAT('%', ?, '%')
    )";
    array_push($params, $tlang, $q, $needle, $needle, $needle);
    $types .= "sssss";
  } else {
    // Короткие подстроки: надёжный LIKE по COALESCE
    $sql .= " AND (
      LOWER(COALESCE(t.name, s.name)) LIKE CONCAT('%', ?, '%')
      OR LOWER(COALESCE(t.specialty, s.specialty)) LIKE CONCAT('%', ?, '%')
      OR LOWER(COALESCE(t.bio, s.bio)) LIKE CONCAT('%', ?, '%')
    )";
    array_push($params, $needle, $needle, $needle);
    $types .= "sss";
  }
}

$sql .= " ORDER BY s.rating DESC, s.experience DESC, name ASC";

$stmt = $mysqli->prepare($sql);
if (!$stmt) {
  http_response_code(500);
  echo json_encode(['error' => 'SQL prepare failed'], JSON_UNESCAPED_UNICODE);
  exit;
}
$stmt->bind_param($types, ...$params);
$stmt->execute();
$res = $stmt->get_result();

$out = [];
while ($row = $res->fetch_assoc()) $out[] = $row;

echo json_encode($out, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
