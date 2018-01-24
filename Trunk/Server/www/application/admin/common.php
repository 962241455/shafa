<?php
/**
 * desc 扩展模版方法
 */

use app\common;
use think\Request;
use think\Session;


/**
 * 插件封装
 */
function function_html_plug($name, $type, $val, $required, $place = '', $url = '', $disabled = false)
{

    $input = ['text', 'hidden', 'number', 'tel', 'date', 'email', 'file', 'password', 'reset', 'textarea'];
    $special = ['checkbox', 'radio', 'select'];
    if (in_array($type, $input)) {
        return function_html_input($name, $type, $val, $required,$place, $disabled);
    } elseif (in_array($type, $special)) {
        return function_html_check_radio($name, $type, $val, $disabled);
    } elseif ($type == 'richtext') {
        return function_html_editor($name, $val, $url);
    } else {
        return '没有找到该类型';
    }
    return false;
}

/**
 * desc 常规inpit 封装
 * name 名称
 * val 值
 * place 注释
 * disabled 是否只读
 * type 类型
 * button    定义可点击按钮
 * checkbox    定义复选框。
 * file    定义输入字段和 "浏览"按钮，供文件上传。
 * hidden    定义隐藏的输入字段
 * image    定义图像形式的提交按钮
 * password    定义密码字段
 * radio    定义单选按钮
 * reset    定义重置按钮
 * submit    定义提交按钮
 * text  定义单行的输入字段
 * return  html || array
 */
function function_html_input($name, $type, $val, $required = '0', $place, $disabled = false)
{
    if (empty($type) || empty($name)) {
        return false;
    }
    $html = '';
    $disa = '';
    if ($disabled) {
        $disa = 'disabled';
    }

    $inputHtml = "<input id='#name' class='form-control' type='#type' name='#name' value='#value' placeholder='#placeholder' {$disa} required='#required' aria-required='true' />";
    switch ($type) {
        case 'text':
            $html = str_replace(['#type', '#name', '#value', '#required', "#placeholder"],
                [$type, $name, $val, $required, $place], $inputHtml);
            break;
        case "hidden":
            $html = str_replace(['#type', '#name', '#value', '#required', "#placeholder"],
                [$type, $name, $val, $required, $place], $inputHtml);
            break;
        case "number":
            $html = str_replace(['#type', '#name', '#value', '#required', "#placeholder"],
                [$type, $name, $val, $required, $place], $inputHtml);
            break;
        case "tel":
            $html = str_replace(['#type', '#name', '#value', '#required', "#placeholder"],
                [$type, $name, $val, $required, $place], $inputHtml);
            break;
        case "date":
            $html = str_replace(['#type', '#name', '#value', '#required', "#placeholder"],
                [$type, $name, $val, $required, $place], $inputHtml);
            break;
        case "email":
            $html = str_replace(['#type', '#name', '#value', '#required', "#placeholder"],
                [$type, $name, $val, $required, $place], $inputHtml);
            break;
        case "hidden":
            $html = str_replace(['#type', '#name', '#value', '#required', "#placeholder"],
                [$type, $name, $val, $required, $place], $inputHtml);
            break;
        case "file":
            $html = str_replace(['#type', '#name', '#value', '#required', "#placeholder"],
                [$type, $name, $val, $required, $place], $inputHtml);
            break;
        case "password":
            $html = str_replace(['#type', '#name', '#value', '#required', "#placeholder"],
                [$type, $name, $val, $required, $place], $inputHtml);
            break;
        case "reset":
            $html = str_replace(['#type', '#name', '#value', '#required', "#placeholder"],
                [$type, $name, $val, $required, $place], $inputHtml);
            break;
        case "textarea":
            $textarea = "<textarea  name='#name' class='form-control input-textarea'  required='#required' aria-required='true'>#value</textarea>";
            $html = str_replace(['#name', '#value', '#required'],
                [$name, $val, $required], $textarea);
            break;
        default:
            return '没有找到该类型';
            break;
    }
    return $html;
}

/**
 * desc 按钮封装
 * name 名称
 * class 样式
 * place 注释
 * disabled 点击失效
 * type 类型
 * button    定义可点击按钮
 * submit    定义提交按钮
 * return  html || array
 */
function function_html_button($name, $type, $class, $disabled = false)
{
    if (empty($type) || empty($name)) {
        return false;
    }
    $html = '';
    $disa = '';
    if ($disabled) {
        $disa = 'disabled';
    }
    //默认样式
    $class = $class ?: "btn-primary";
    $inputHtml = "<button class='btn #class' type='#type'{$disa}> #name </button>";

    switch ($type) {
        case 'image':
        case "image":
            $html = str_replace(['#type', '#name', '#class'],
                [$type, $name, $class], $inputHtml);
            break;
        case "button":
            $html = str_replace(['#type', '#name', '#class'],
                [$type, $name, $class], $inputHtml);
            break;
        case "submit":
            $html = str_replace(['#type', '#name', '#class'],
                [$type, $name, $class], $inputHtml);
            break;
        default:
            return '没有找到该类型';
            break;
    }
    return $html;
}

/**
 * desc 选择封装
 * data array 一组键对值 [k => name ,val => value, chenck => checked ,place => '注释' ]
 * disabled 是否只读
 * type
 * button    定义可点击按钮
 * submit    定义提交按钮
 * return  html || array
 */
function function_html_check_radio($name, $type, $data)
{
    if (empty($type) || empty($name) || empty($data)) {
        return false;
    }
    $html = '';
    $disa = '';
    switch ($type) {
        case "checkbox":

            foreach ($data as $val) {
                $checked = '';
                $disabled = '';
                $html .= "<div class='checkbox i-checks'>
                          <label><input type='checkbox' value='{$val}' {$disabled} {$checked} name='{$name}[]' value='{$val["value"]}'> <i></i>{$val["name"]}</label>
                          </div>";
            }
            break;
        case "radio":

            foreach ($data as $val) {
                $checked = '';
                $disabled = '';
                $html .= "<div class='radio i-checks'>
                         <label><input type='radio'{$disabled} {$checked} name='{$name}' value='{$val["value"]}'> <i></i>{$val["name"]}</label>
                        </div>
                        ";
            }
            break;
        case 'select':
            $html = "<select class='form-control m-b' name='{$name}'>
                        <option value='0'>请选择</option>";
            foreach ($data as $val) {
                $html .= "<option value='{$val}' >{$val}</option>";
            }
            $html .= "</select>";
            break;
        default:
            return '没有找到该类型';
            break;
    }
    return $html;
}

/**
 * 富文本编辑器
 * @param array  $obj 编辑器的容器id或class
 * @param string $name [为了方便大家能在系统设置里面灵活选择编辑器，建议不要指定此参数]，目前支持的编辑器[ueditor,umeditor,ckeditor,kindeditor]
 * @param string $url [选填]附件上传地址，建议保持默认
 * @return html
 */
function function_html_editor($name = '', $value, $url = '')
{
    if (empty($name)) {
        return '没有找到该类型';
    }
    if (empty($url)) {
        $url = url("/upload/" . $name);
    }
    $time = time();
    $html = <<<ENT
        <script id='{$name}' name={$name} type='text/plain' style='height: 300px'>{$value}</script>
        <script src="/static/umeditor/ueditor.config.js?tid={$time}"></script>
        <script src="/static/umeditor/ueditor.all.min.js?tid={$time}"></script>
        <script src="/static/umeditor/lang/zh-cn/zh-cn.js?tid={$time}"></script>
        <script>    
            var ue = UE.getEditor('{$name}',{
                    initialFrameWidth:"100%",
                    initialFrameHeight:"200",
                    // imageUrl:"{$url}",
                    imageFieldName:"upfile"
            }); 
        </script>
ENT;

    return $html;
}
