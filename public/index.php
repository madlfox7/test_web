<?php
declare(strict_types=1);

$uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);

// Маршруты: список и карточка
if (preg_match('#^/(en|ru|hy)/specialists(?:/([\w-]+)/?)?$#', $uri, $m)) {
  $lang = $m[1];
  $slug = $m[2] ?? null;

  header('Content-Type: text/html; charset=utf-8');

  if ($slug) {
    // Детальная страница специалиста (заглушка)
    $title = ($lang==='ru'?'Специалист':'Specialist')." $slug — PsyAid";
    echo "<!doctype html><html lang=\"$lang\"><head><meta charset=\"utf-8\"><title>$title</title></head><body>";
    echo "<h1>Specialist: ".htmlspecialchars($slug)."</h1>";
    echo "<p><a href=\"/$lang/specialists/\">← Back to list</a></p>";
    echo "</body></html>";
    exit;
  } else {
    // Список (заглушка)
    $title = $lang==='ru' ? 'Специалисты — PsyAid' : ($lang==='hy' ? 'Մասնագետներ — PsyAid' : 'Specialists — PsyAid');
    echo "<!doctype html><html lang=\"$lang\"><head><meta charset=\"utf-8\"><title>$title</title></head><body>";
    echo "<h1>$title</h1>";
    echo "<ul>";
    echo "<li><a href=\"/$lang/specialists/anahit-m/\">Anahit M.</a></li>";
    echo "<li><a href=\"/$lang/specialists/aram-k/\">Aram K.</a></li>";
    echo "</ul>";
    echo "</body></html>";
    exit;
  }
}

http_response_code(404);
header('Content-Type: text/plain; charset=utf-8');
echo "Not found";
