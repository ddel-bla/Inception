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

if ( ! defined('ABSPATH') ) {
	define('ABSPATH', __DIR__ . '/');
}

require_once ABSPATH . 'wp-settings.php';
