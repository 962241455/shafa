<?php
// +----------------------------------------------------------------------
// | [基于ThinkPHP5开发]
// +----------------------------------------------------------------------
namespace app\common\behavior;
use Think\Lang;
use think\View as ViewTemplate;
use think\Request;
use think\Response;
use think\exception\HttpResponseException;
use think\Url;
use think\Config;

/**
 * 初始化基础配置行为
 * 将扩展的全局配置本地化
 */
class Base
{
    public function run(&$params)
    {
        // 获取当前模块名称
        $module = '';
        $dispatch = request()->dispatch();
        if (isset($dispatch['module'])) {
            $module = $dispatch['module'][0];
        }
    }

    private function error($msg = '', $url = null, $data = '', $wait = 3, array $header = [])
    {
        if (is_null($url)) {
            $url = Request::instance()->isAjax() ? '' : 'javascript:history.back(-1);';
        } elseif ('' !== $url && !strpos($url, '://') && 0 !== strpos($url, '/')) {
            $url = Url::build($url);
        }

        $result = [
            'code' => 0,
            'msg'  => $msg,
            'data' => $data,
            'url'  => $url,
            'wait' => $wait,
        ];

        $template = Config::get('template');
        $view = Config::get('view_replace_str');

        return ViewTemplate::instance($template, $view)
            ->fetch(Config::get('dispatch_error_tmpl'), $result);

    }
}
