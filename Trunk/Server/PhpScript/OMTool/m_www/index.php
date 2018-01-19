<?php
include("base.php");
defined('YII_DEBUG') or define('YII_DEBUG', true);
defined('YII_ENV') or define('YII_ENV', 'dev');
define("YII_ENV_DEV", false);

define('PROJECT_PATH',__DIR__.'/../app');
define('VENDOR_PATH',__DIR__.'/../../PhpExt/vendor');
define("ROOT_DIR", __DIR__.'/..');
define("APP_DIR", ROOT_DIR . '/app/mobile');
define("WWW_PATH", ROOT_DIR . '/m_www');

define("IS_REWRITE", 0);

require(VENDOR_PATH . '/autoload.php');
require(VENDOR_PATH . '/yiisoft/yii2/Yii.php');
$config = require(APP_DIR . '/config/web.php');
$application = new yii\web\Application($config);
$application->run();
