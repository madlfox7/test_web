<?php
$host = 'db';
$user = 'psyaid';
$pass = 'psyaidpass';
$db   = 'psyaid';

mysqli_report(MYSQLI_REPORT_OFF);

$tries = 0;
do {
  $mysqli = @new mysqli($host, $user, $pass, $db);
  if (!$mysqli->connect_errno) break;
  usleep(500000); // 0.5s
  $tries++;
} while ($tries < 60); // до ~30 секунд

if ($mysqli->connect_errno) {
  http_response_code(503);
  header('Content-Type: application/json; charset=utf-8');
  echo json_encode(['error' => 'DB unavailable'], JSON_UNESCAPED_UNICODE);
  exit;
}
$mysqli->set_charset('utf8mb4');
