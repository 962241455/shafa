<!DOCTYPE html>
<html>
<head>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>登录</title>
    <meta name="keywords" content="">
    <meta name="description" content="">

    <link type="text/css" rel="stylesheet" href="{:stamp('css/bootstrap.min.css')}"/>
    <link href="{:stamp('css/font-awesome.min.css')}" rel="stylesheet">
    <link type="text/css" rel="stylesheet" href="{:stamp('css/animate.min.css')}"/>
    <link type="text/css" rel="stylesheet" href="{:stamp('css/style.min.css')}"/>
    <script src="{:stamp('js/jquery.min.js')}"></script>
    <!--[if lt IE 8]>
    <meta http-equiv="refresh" content="0;ie.html" />
    <![endif]-->
    <script>if(window.top !== window.self){ window.top.location = window.location;}</script>
</head>

<body class="gray-bg">

<div class="middle-box text-center loginscreen  animated fadeInDown">
    <div>
        <div><h1 class="logo-name">logo</h1></div>
        <h2 style="margin-top:120px;">沙发配色管理后台</h2>
        <form class="m-t" role="form" action="{:url('admins/login')}" method="post">
            {:token()}
            <div class="form-group">
                <input type="input" class="form-control" placeholder="用户名" name="username" value="{$from.username?:''}">
            </div>
            <div class="form-group">
                <input type="password" class="form-control" placeholder="密码" name="password" value="{$from.password?:''}">
            </div>
            {if $error != 1 && $error }
                <div class="alert alert-danger">{$error}</div>
            {/if}
            <button type="submit" class="btn btn-primary block full-width m-b">登 录</button>
<!--            <p class="text-muted text-center"> <a href="login.html#"><small>忘记密码了？</small></a> | <a href="register.html">注册一个新账号</a>-->
            </p>

        </form>
    </div>
</div>
</body>

</html>