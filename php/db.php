<?php
$host = 'psyaid_db';
$user = 'psyaid';
$pass = 'psyaidpass';
$db   = 'psyaid';

mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);
$mysqli = new mysqli($host, $user, $pass, $db);
$mysqli->set_charset('utf8mb4');
