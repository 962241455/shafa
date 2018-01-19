<?php
// +----------------------------------------------------------------------
// | HisiPHP框架[基于ThinkPHP5开发]
// +----------------------------------------------------------------------
// | Copyright (c) 2016-2018 http://www.hisiphp.com
// +----------------------------------------------------------------------
// | HisiPHP承诺基础框架永久免费开源，您可用于学习和商用，但必须保留软件版权信息。
// +----------------------------------------------------------------------
// | Author: 橘子俊 <364666827@qq.com>，开发者QQ群：50304283
// +----------------------------------------------------------------------
namespace app\admin\validate;

use think\Validate;

/**
 * 配置验证器
 * @package app\admin\validate
 */
class Admins extends Validate
{
    //定义验证规则
    protected $rule = [
        'username' => 'require',
        'password' => 'require',
        '__token__'    => 'require',
    ];

    //定义验证提示
     protected $message = [
         'username.require' => '用户名不能为空',
         'password.require'    => '密码不能为空',
         '__token__.require'    => 'token不存在',
     ];
}
