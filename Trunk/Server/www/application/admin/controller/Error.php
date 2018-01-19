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

class Error extends AdminCommon
{
    public function index()
    {

        return view('index');
    }
    public function phpinfo()
    {
         echo  phpinfo();
    }
}
