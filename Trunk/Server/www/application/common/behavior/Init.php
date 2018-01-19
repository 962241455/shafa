<?php
// +----------------------------------------------------------------------
// |[基于ThinkPHP5开发]
// +----------------------------------------------------------------------
namespace app\common\behavior;
use think\Request;
/**
 * 应用初始化行为
 */
class Init
{
    public function run(&$params)
    {
        define('IN_SYSTEM', true);
        $request = Request::instance();
        // 安装操作直接return
        if(defined('BIND_MODULE') && BIND_MODULE == 'install') return;
        $_path = $request->path();
        $default_module = false;
        if ($_path != '/' && !defined('BIND_MODULE')) {
            $_path = explode('/', $_path);
            if (isset($_path[0]) && !empty($_path[0])) {
                if (is_dir('./app/'.$_path[0]) || $_path[0] == 'plugins') {
                    $default_module = true;
                    if ($_path[0] == 'plugins') {
                        define('BIND_MODULE', 'index');
                        define('PLUGIN_ENTRANCE', true);
                    }
                }
            }
        }

        // 后台强制关闭路由
        if (defined('ENTRANCE') && ENTRANCE == 'admin') {
            config('url_route_on', false);
        }
    }
}
