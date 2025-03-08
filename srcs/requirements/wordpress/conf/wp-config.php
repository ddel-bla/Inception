<?php
define('DB_NAME', getenv("MDB_NAME"));
define('DB_USER', getenv("MDB_USER"));
define('DB_PASSWORD', getenv("MDB_USER_PASSWORD"));
define('DB_HOST', 'mariadb');
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');

define('AUTH_KEY',         bin2hex(random_bytes(32)));
define('SECURE_AUTH_KEY',  bin2hex(random_bytes(32)));
define('LOGGED_IN_KEY',    bin2hex(random_bytes(32)));
define('NONCE_KEY',        bin2hex(random_bytes(32)));
define('AUTH_SALT',        bin2hex(random_bytes(32)));
define('SECURE_AUTH_SALT', bin2hex(random_bytes(32)));
define('LOGGED_IN_SALT',   bin2hex(random_bytes(32)));
define('NONCE_SALT',       bin2hex(random_bytes(32)));

$table_prefix = 'wp_';
define('WP_DEBUG', false);

// Forzar HTTPS
define('FORCE_SSL_ADMIN', true);
define('FORCE_SSL_LOGIN', true);
define('WP_HOME', getenv("WP_URL"));
define('WP_SITEURL', getenv("WP_URL"));

// Forzar comportamiento consistente para URLs y archivos estáticos
if (strpos($_SERVER['HTTP_X_FORWARDED_PROTO'], 'https') !== false)
    $_SERVER['HTTPS'] = 'on';

if ( ! defined('ABSPATH') ) {
    define('ABSPATH', __DIR__ . '/');
}

require_once ABSPATH . 'wp-settings.php';