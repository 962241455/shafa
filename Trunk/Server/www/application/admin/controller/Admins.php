<?php

namespace app\admin\controller;

use think\Controller;
use app\common\util\Http;
use think\Session;
use think\Request;
use think\Validate;
use think\Cache;
use think\config;
use think\View;

class Admins extends Controller
{
    public function login(Request $request)
    {
        $result = $this->request->param('message','');
        if ($from = $this->request->post()) {
            $secc = Validate::token('__token__', '', ['__token__' => $from['__token__']]);
            if ($secc) {
                $result = $this->validate($from, 'Admins');
                if ($result === true) {
                    $return = Http::getRequest(ADMIN_GM_URL, ['gmName' => $from['username'], 'gmPass' => $from['password'], 'action' => 'GMLogin']);
                    if ($return['code'] == 0) {
                        Session::set('adminSess', $return['result']);
                        $this->redirect("index/index");
                    } else {
                        return view('login', ['from' => $from, 'error' => $return['message']]);
                    }
                }
            }
        }
        return view('login', ['from' => $from, 'error' => $result]);
    }

    /**
     * desc 注销
     */
    public function logout()
    {
        Session::clear(); //清空所有session
        Cache::clear(); //清空缓存
        //session_destroy();
        $this->redirect('Admins/login');
    }
}
