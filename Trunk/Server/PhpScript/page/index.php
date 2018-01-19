<?php

define('REQUEST_TIME', time());
define("WEB_DOMAIN", $_SERVER['HTTP_HOST']);
define("WEB_URL", 'http://' . WEB_DOMAIN);
define("IMG_URL", 'http://' . WEB_DOMAIN . '/uploads/img');
define("S_URL", 'http://' . WEB_DOMAIN . '/statics');

defined('YII_DEBUG') or define('YII_DEBUG', true);
defined('YII_ENV') or define('YII_ENV', 'dev');
define("YII_ENV_DEV", false);

//define("WEB_SOFA", "http://127.0.0.1:9101/main");
define("WEB_SOFA", $_SERVER['APP_RPC_URL']);
define("VERSION", $_SERVER["APP_VERSION"]);
define("PLATFORM", $_SERVER["APP_PLATFORM"]);

define('PROJECT_PATH', __DIR__ . '/app');
define('VENDOR_PATH', __DIR__ . '/../PhpExt/vendor');
define("ROOT_DIR", __DIR__);
define("APP_DIR", ROOT_DIR . '/app/mobile');

define("IS_REWRITE", 0);
//var_dump(APP_DIR);exit;
require(VENDOR_PATH . '/autoload.php');
require(VENDOR_PATH . '/yiisoft/yii2/Yii.php');

$config = require(APP_DIR . '/config/web.php');
$application = new yii\web\Application($config);
$application->run();


function pr($data, $exit = false)
{
    echo "<pre>" ;
    print_r($data);
    echo "</pre>";
    if ($exit) die();
}