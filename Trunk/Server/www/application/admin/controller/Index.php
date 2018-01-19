<?php
namespace app\admin\controller;

use app\common\controller\AdminCommon;
use app\common\util\Http;
use app\constEnv;
use think\Session;
use think\Request;
use think\Validate;
use think\config;
use think\View;

class Index extends AdminCommon
{
    public function index()
    {
        $adminList = Session::get("adminSess");
        $admins = '';
        $this -> assign('admins', $admins);
        return view('index',['title'=>'首页']);
    }
    public function phpinfo()
    {
         echo  phpinfo();
    }
}
