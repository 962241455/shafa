<?php
// +----------------------------------------------------------------------
// | ThinkPHP [ WE CAN DO IT JUST THINK ]
// +----------------------------------------------------------------------
// | Copyright (c) 2006-2016 http://thinkphp.cn All rights reserved.
// +----------------------------------------------------------------------
// | Licensed ( http://www.apache.org/licenses/LICENSE-2.0 )
// +----------------------------------------------------------------------
// | Author: liu21st <liu21st@gmail.com>
// +----------------------------------------------------------------------

// [ 应用入口文件 ]

// 定义应用目录
define('APP_PATH', __DIR__ . '/../application/');
define('APP_STATIC', __DIR__ . '/../public/static/');
define('BIND_MODULE', 'index');

//引入自定义配置
require __DIR__ . '/../extend' . '/const.php';
// 加载框架引导文件
require __DIR__ . '/../thinkphp/start.php';
\think\App::route(false);