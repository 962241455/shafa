<?php
/**
 * 自定义常量
 */

//后端服务器接口地址
define('ADMIN_GM_URL', $_SERVER["APP_GMS_URL"]);
//前端服务器接口地址
define('WEB_RPC_URL', $_SERVER["APP_RPC_URL"]);

//服务器版本号
define("VERSION", $_SERVER["APP_VERSION"]);
//平台
define("PLATFORM", $_SERVER["APP_PLATFORM"]);