<?php

namespace app\index\controller;

use app\common\controller\IndexCommon;
use think\Request;
use think\Validate;
use think\View;
use think\config;
use app\common\util\Http;
use app\constEnv;

class Notice extends IndexCommon
{
    public function index()
    {
        $request = $this->request->param();
        if ($request['uid'] && $request['token']) {
            $data = Http::getRequest(WEB_RPC_URL, [
                'action' => 'GetSysNotice',
                'uid' => $request['uid'],
                'token' => $request['token']
            ]);
        } else {
            $data = [
                'code' => 1,
                'message' => "请求参数不正确。"
            ];
        }
        return view('index', ['title' => '通知', 'data' => $data, 'form' => $request]);
    }

    public function detail()
    {
        $request = $this->request->param();
        if ($request['uid'] && $request['token'] && $request['id']) {
            $data = Http::getRequest(WEB_RPC_URL, [
                'action' => 'GetOneMail',
                'guid' => $request['id'],
                'uid' => $request['uid'],
                'token' => $request['token']
            ]);
        } else {
            $data = [
                'code' => 1,
                'message' => "请求参数不正确。"
            ];
        }
        return view('detail', ['title' => '通知详情', 'data' => $data, 'form' => $request]);
    }

    public function read()
    {
        if ($request = $this->request->post()) {
            if ($request['uid'] && $request['token'] && $request['id']) {
                $data = Http::getRequest(WEB_RPC_URL, [
                    'action' => 'ReadMailTag',
                    'mail_id' => $request['id'],
                    'uid' => $request['uid'],
                    'token' => $request['token'],
                    'read_flag' => 1
                ]);
            } else {
                $data = [
                    'code' => 1,
                    'message' => "请求参数不正确。"
                ];
            }
        }
        return json_encode($data);
    }

}
