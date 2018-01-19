<?php
header("Content-type: text/html; charset=utf-8");
define('RUN_WEB', 1);
if(!RUN_WEB){
    echo '服务器正在维护...';
    exit;
}

define('RUN_PATTERN', 'test');
define('REQUEST_TIME', time());
define('USER_PRE', 'hdzq');

//define("WEB_SOFA", "http://127.0.0.1:9101/main");
define("WEB_GM", $_SERVER["APP_GMS_URL"]);
//define("WEB_GM", 'http://127.0.0.1:9101/gms');
define("WEB_DOMAIN", $_SERVER['HTTP_HOST']);
define("WEB_URL", 'http://'.WEB_DOMAIN);
define("IMG_URL", 'http://'.WEB_DOMAIN.'/uploads/img');
define("S_URL", 'http://'.WEB_DOMAIN.'/statics');