<?php
namespace app\index\controller;

use app\common\controller\IndexCommon;
use think\View;
use think\config;
use think\env;

class Index extends IndexCommon
{
    public function index()
    {
        $this->redirect('Notice/index');
    }
    public function phpinfo()
    {
        echo  phpinfo();
    }
}
