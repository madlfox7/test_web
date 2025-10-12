<?php
header('Content-Type: application/json; charset=utf-8');
require __DIR__ . '/db.php';

$q       = isset($_GET['q']) ? trim($_GET['q']) : '';
$city    = isset($_GET['city']) ? trim($_GET['city']) : '';
$lang    = isset($_GET['lang']) ? trim($_GET['lang']) : '';
$active  = 1;

$sql = "SELECT id, name, specialty, city, languages, experience, price_from, rating
        FROM specialists
        WHERE is_active = ?";

$params = [$active];
$types  = "i";

if ($q !== '') {
  $sql .= " AND (name LIKE CONCAT('%', ?, '%') OR specialty LIKE CONCAT('%', ?, '%'))";
  $params[] = $q; $params[] = $q;
  $types   .= "ss";
}
if ($city !== '') {
  $sql .= " AND city = ?";
  $params[] = $city;
  $types   .= "s";
}
if ($lang !== '') {
  $sql .= " AND FIND_IN_SET(?, REPLACE(languages, ' ', '')) > 0";
  $params[] = $lang;
  $types   .= "s";
}

$sql .= " ORDER BY rating DESC, experience DESC, name ASC";

$stmt = $mysqli->prepare($sql);
$stmt->bind_param($types, ...$params);
$stmt->execute();
$res = $stmt->get_result();

$out = [];
while ($row = $res->fetch_assoc()) $out[] = $row;

echo json_encode($out, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
