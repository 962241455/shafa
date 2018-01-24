<?php
// +----------------------------------------------------------------------
// | [基于ThinkPHP5开发]
// +----------------------------------------------------------------------
namespace app\common\controller;

use think\View;
use think\Controller;
use think\Session;
use think\Cache;
use think\config;

/**
 * 项目公共控制器
 * @package app\common\controller
 */
class AdminCommon extends Controller
{

    /**
     * 初始化控制器
     */
    protected function _initialize()
    {
        $adminList = Session::get("adminSess");
        //判断登录session
        if (empty($adminList)) {
            $this->redirect('admins/login');
        }

        //判断GM操作权限
        if (empty($adminList['gmList'])){
            $this->redirect('admins/login',['message' => '账户无操作权限']);
        }
        $menudata = $this->menu($adminList['gmList']);
//        pr($menudata);
        $this->view->assign("menudata", $menudata);

        // 判断GM信息
        if (empty($adminList['gmInfo'])){
            $this->redirect('admins/login',['message' => '暂无账户信息']);
        }
        $this->view->assign("admin", $adminList['gmInfo']);
    }

    /**
     * 渲染后台模板
     * 模块区分前后台时需用此方法
     * @param string $template 模板路径
     * @author
     * @return string
     */
    protected function afetch($template = '') {

        if ($template) {
            return $this->fetch($template);
        }

        $dispatch = request()->dispatch();
        if (!$dispatch['module'][2]) {
            $dispatch['module'][2] = 'index';
        }
        return $this->fetch($dispatch['module'][1].DS.$dispatch['module'][2]);
    }
    
    /**
     * 渲染插件模板
     * @param string $template 模板名称
     * @author
     * @return mixed
     */
    final protected function pfetch($template = '', $vars = [], $replace = [], $config = [])
    {
        $plugin = $_GET['_p'];
        $controller = $_GET['_c'];
        $action = $_GET['_a'];
        $template = $template ? $template : $controller.'/'.$action;
        if(defined('ENTRANCE') && ENTRANCE == 'admin') {
            $template = 'admin/'.$template;
        }
        $template_path = strtolower("plugins/{$plugin}/view/{$template}.".config('template.view_suffix'));
        return parent::fetch($template_path, $vars, $replace, $config);
    }

    /**
     * 渲染菜单
     * @param array $menu 菜单名称
     * @author
     * @return mixed
     */
    public function menu($menu = [])
    {
        if(empty($menu)){
            return false;
        }
        $menudata = [];
        $icon = ['user',  'cog','align-justify', 'envelope','exclamation-sign'];
        foreach($menu as $k => $item){
            $item['icon'] = $icon[$k];
            //菜单加入缓存
            foreach ($item['list'] as $value){
                if(!Cache::get($value['action'])){
                    Cache::set($value['action'],json_encode($value), config::get('menu_redis_active_time'));
                }
            }
            $menudata[] = $item;
        }
        return $menudata;
    }
}