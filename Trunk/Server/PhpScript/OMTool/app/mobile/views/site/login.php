<?php
$this->title = "沙发配色管理后台 | 用户登录";

?>

<div class="login">
    <!-- BEGIN SIDEBAR TOGGLER BUTTON -->
    <div class="menu-toggler sidebar-toggler">
    </div>
    <!-- END SIDEBAR TOGGLER BUTTON -->
    <!-- BEGIN LOGO -->
    <div class="logo">
        <a href="javascript:;" id="webnama">
            沙发配色管理后台
        </a>
    </div>
    <!-- END LOGO -->
    <!-- BEGIN LOGIN -->
    <div class="content">
        <!-- BEGIN LOGIN FORM -->
        <form class="login-form" action="index.php?r=site/login" method="post">
            <input type="hidden" name="action" value="GMLogin">
            <h3 class="form-title">登 录</h3>
            <div class="alert alert-danger display-hide">
                <button class="close" data-close="alert"></button>
                <span>请输入用户名和密码</span>
            </div>
            <div class="form-group">
                <!--ie8, ie9 does not support html5 placeholder, so we just show field title for that-->
                <label>用户名</label>
                <input class="form-control form-control-solid placeholder-no-fix" type="text" autocomplete="off"
                       placeholder="用户名" name="LoginForm[username]"/>
            </div>
            <div class="form-group">
                <label>密码</label>
                <input class="form-control form-control-solid placeholder-no-fix" type="password" autocomplete="off"
                       placeholder="密码" name="LoginForm[password]"/>
            </div>
            <div class="form-actions">
                <button id="login" type="button" class="btn btn-success uppercase">登录</button>
                <label class="rememberme check">
                    <input type="checkbox" name="LoginForm[remember]" value="1"/>记住登录 </label>
            </div>
        </form>
        <!-- END LOGIN FORM -->
    </div>

    <script>
        $(function () {
            $(document).keydown(function (event) {
                if (event.keyCode == 13) {
                    $("#login").click();
                }
            });

            $("#login").click(function () {
                var ajaxUrl = '/index.php?r=site/login';
                $.ajax({
                    type: "POST",
                    url: ajaxUrl,
                    data: $('form').serialize(), // 你的formid
                    dataType: 'json',
                    error: function (request) {
                        alert("Connection error");
                    },
                    success: function (data) {
                        //   console.log(data.status)
                        if (!data.status) {
                            $('.alert-danger', $('.login-form')).show().find('span').text(data.msg);
                        } else {
                            $('.alert-danger', $('.login-form')).show().removeClass('alert-danger').addClass('alert-success').find('span').text(data.msg);
                            location.href = '/index.php?r=site/admin';
                        }
                    }
                });
            });
        })


    </script>
</div>