<?php
// +----------------------------------------------------------------------
// |[基于ThinkPHP5开发]
// +----------------------------------------------------------------------
namespace app\common\behavior;
/**
 * 注册钩子
 * @package app\common\behavior
 */
class Hook
{
    public function run(&$params)
    {
        // 安装操作直接return
        if(defined('BIND_MODULE') && BIND_MODULE == 'install') return;
        $hook_plugins = cache('hook_plugins');
        $hooks        = cache('hooks');
        $plugins      = cache('plugins');

        // 全局插件
        if ($hook_plugins) {
            foreach ($hook_plugins as $value) {
                if (isset($hooks[$value->hook]) && isset($plugins[$value->plugins])) {
                    \think\Hook::add($value->hook, get_plugins_class($value->plugins));
                }
            }
        }
    }
}
