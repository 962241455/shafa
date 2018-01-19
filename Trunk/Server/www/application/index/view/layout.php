<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport"
          content="width=device-width,initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no"/>
    <meta name="format-detection" content="telephone=no"/>
    <meta name="renderer" content="webkit">
    <meta http-equiv="Cache-Control" content="no-siteapp"/>
    <title>{$title}</title>
    <meta name="keywords" content="">
    <meta name="description" content="">

    <!--[if lt IE 8]>
    <meta http-equiv="refresh" content="0;ie.html"/>
    <![endif]-->
    <link type="text/css" rel="stylesheet" href="{:stamp('index/css/addone.css')}"/>
    <link type="text/css" rel="stylesheet" href="{:stamp('index/css/layui.css')}"/>
    <script src="{:stamp('js/jquery.min.js')}"></script>
    <script src="{:stamp('index/js/layui.js')}"></script>
</head>

<body >
<div id="wrapper">
    {block name="content"}
        {$content}
    {/block}
</div>

</body>
</html>