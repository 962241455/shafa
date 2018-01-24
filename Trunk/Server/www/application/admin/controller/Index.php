<?php

namespace app\admin\controller;

use app\common\controller\AdminCommon;
use app\common\util\Http;
use app\constEnv;
use think\Request;
use think\Validate;
use think\config;
use think\Cache;
use think\View;

class Index extends AdminCommon
{
    /**
     * @dasc 首页
     * @return  view
     */
    public function index()
    {
        $message = $this->request->param('message');
        $adminList = $this->afetch();
        $admins = '';
        $this->assign('admins', $admins);
        return view('index', ['message' => $message]);
    }

    /**
     * @dasc 增加修改
     * @return array
     */
    public function input(Request $request)
    {
//        function_html_input('text',['k'=>'names','val'=>'112','place' => "添加"]);
        $action = $this->request->param("action");
        $menuList = json_decode(Cache::get($action), true);
        if (!$menuList) {
            $this->redirect("index/index", ['message' => '操作不存在']);
        }
        return view('input', ['data' => $menuList]);
    }

    /**
     * @dasc 提交请求
     * @return array
     */
    public function formHttp(Request $request)
    {
        $error = [];
        if ($form = $this->request->param()) {

        }else{
            $error = ['code'=> '1','meeage'=> '提交数据不能为空'];
        }

        return json_encode($error);
    }

    public function test()
    {
        return view('test');
    }

}
