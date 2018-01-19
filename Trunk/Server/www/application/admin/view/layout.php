<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="renderer" content="webkit">
    <meta http-equiv="Cache-Control" content="no-siteapp"/>
    <title>主页</title>
    <meta name="keywords" content="">
    <meta name="description" content="">

    <!--[if lt IE 8]>
    <meta http-equiv="refresh" content="0;ie.html"/>
    <![endif]-->
    <link type="text/css" rel="stylesheet" href="{:stamp('css/bootstrap.min.css')}"/>
    <link type="text/css" rel="stylesheet" href="{:stamp('css/font-awesome.min.css')}"/>
    <link type="text/css" rel="stylesheet" href="{:stamp('css/animate.min.css')}"/>
    <link type="text/css" rel="stylesheet" href="{:stamp('css/style.min.css')}"/>
    <script src="{:stamp('js/jquery.min.js')}"></script>
    <script src="{:stamp('js/bootstrap.min.js')}"></script>
    <script src="{:stamp('js/plugins/metisMenu/jquery.metisMenu.js')}"></script>
    <script src="{:stamp('js/plugins/slimscroll/jquery.slimscroll.min.js')}"></script>
    <script src="{:stamp('js/plugins/layer/layer.min.js')}"></script>
    <script src="{:stamp('js/hplus.min.js')}"></script>
    <script src="{:stamp('js/contabs.min.js')}"></script>
    <script src="{:stamp('js/plugins/pace/pace.min.js')}"></script>
</head>

<body class="fixed-sidebar full-height-layout gray-bg">
<div id="wrapper">
    {include file="common/menu" /}
    {block name="content"}
        {$content}
    {/block}
</div>

</body>
</html>