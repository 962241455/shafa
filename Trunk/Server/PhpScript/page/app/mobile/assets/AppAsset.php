<?php

namespace app\assets;

use yii\web\AssetBundle;

/**
 * Main frontend application asset bundle.
 */
class AppAsset extends AssetBundle
{
    public $basePath = '@web';
    public $baseUrl = '@web/assets';
    public $css = [
        'css/addone.css',
        'css/layui.css',
    ];
    public $js = [
        'js/jquery.min.js',
        'js/layui.js',
    ];
    public $depends = [

    ];
    public $jsOptions = [
        'position' => \yii\web\View::POS_HEAD,// 这是设置所有js放置的位置
    ];
    static function register($view)
    {
        parent::register($view);
    }
    //加载JS
    public static function addScript($view, $jsfile) {
        $view->registerJsFile($jsfile, [AppAsset::className(), 'depends' => 'app\assets\AppAsset']);
    }

    //加载css
    public static function addCss($view, $cssfile) {
        $view->registerCssFile($cssfile, [AppAsset::className(), 'depends' => 'app\assets\AppAsset']);
    }
}