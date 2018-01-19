<?php if (!defined('THINK_PATH')) exit(); /*a:3:{s:99:"D:\phpStudy\WWW\chengwang\mix_App\Trunk\Server\www\public/../application/admin\view\index\index.php";i:1516258600;s:84:"D:\phpStudy\WWW\chengwang\mix_App\Trunk\Server\www\application\admin\view\layout.php";i:1516258638;s:89:"D:\phpStudy\WWW\chengwang\mix_App\Trunk\Server\www\application\admin\view\common\menu.php";i:1516260287;}*/ ?>
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
    <link type="text/css" rel="stylesheet" href="<?php echo stamp('css/bootstrap.min.css'); ?>"/>
    <link type="text/css" rel="stylesheet" href="<?php echo stamp('css/font-awesome.min.css'); ?>"/>
    <link type="text/css" rel="stylesheet" href="<?php echo stamp('css/animate.min.css'); ?>"/>
    <link type="text/css" rel="stylesheet" href="<?php echo stamp('css/style.min.css'); ?>"/>
    <script src="<?php echo stamp('js/jquery.min.js'); ?>"></script>
    <script src="<?php echo stamp('js/bootstrap.min.js'); ?>"></script>
    <script src="<?php echo stamp('js/plugins/metisMenu/jquery.metisMenu.js'); ?>"></script>
    <script src="<?php echo stamp('js/plugins/slimscroll/jquery.slimscroll.min.js'); ?>"></script>
    <script src="<?php echo stamp('js/plugins/layer/layer.min.js'); ?>"></script>
    <script src="<?php echo stamp('js/hplus.min.js'); ?>"></script>
    <script src="<?php echo stamp('js/contabs.min.js'); ?>"></script>
    <script src="<?php echo stamp('js/plugins/pace/pace.min.js'); ?>"></script>
</head>

<body class="fixed-sidebar full-height-layout gray-bg">
<div id="wrapper">
    <!--左侧导航开始-->
<nav class="navbar-default navbar-static-side" role="navigation">
    <div class="nav-close"><i class="fa fa-times-circle"></i>
    </div>
    <div class="sidebar-collapse">
        <ul class="nav" id="side-menu">
            <li class="nav-header">
                <div class="dropdown profile-element">
                    <span><img alt="image" class="img-circle" src="/static/img/profile_small.jpg" /></span>
                    <a data-toggle="dropdown" class="dropdown-toggle" href="#">
                                <span class="clear">
                               <span class="block m-t-xs"><strong class="font-bold">Beaut-zihan</strong></span>
                                <span class="text-muted text-xs block">超级管理员<b class="caret"></b></span>
                                </span>
                    </a>
                    <ul class="dropdown-menu animated fadeInRight m-t-xs">
                        <li><a class="J_menuItem" href="profile.html">个人资料</a></li>
                        <li><a class="J_menuItem" href="contacts.html">联系我们</a></li>
                        <li class="divider"></li>
                        <li><a href="login.html">安全退出</a>
                        </li>
                    </ul>
                </div>
            </li>
            <li>
                <a href="#">
                    <i class="fa fa-home"></i>
                    <span class="nav-label">主页</span>
                </a>
            </li>

            <!--<li>
                <a href="#">
                    <i class="fa fa fa-bar-chart-o"></i>
                    <span class="nav-label">统计图表</span>
                    <span class="fa arrow"></span>
                </a>
                <ul class="nav nav-second-level">
                    <li>
                        <a class="J_menuItem" href="graph_echarts.html">百度ECharts</a>
                    </li>
                    <li>
                        <a class="J_menuItem" href="graph_flot.html">Flot</a>
                    </li>
                </ul>
            </li>-->

            <li>
                <a href="mailbox.html"><i class="fa fa-envelope"></i> <span class="nav-label">通知消息 </span><span class="fa arrow"></span></a>
                <ul class="nav nav-second-level">
                    <li><a class="J_menuItem" href="mailbox.html">收件箱</a>
                    </li>
                    <li><a class="J_menuItem" href="mail_detail.html">查看邮件</a>
                    </li>
                    <li><a class="J_menuItem" href="mail_compose.html">写信</a>
                    </li>
                </ul>
            </li>
            <li>
                <a href="#"><i class="fa fa-edit"></i> <span class="nav-label">表单</span><span class="fa arrow"></span></a>
                <ul class="nav nav-second-level">
                    <li><a class="J_menuItem" href="form_basic.html">基本表单</a>
                    </li>
                    <li><a class="J_menuItem" href="form_validate.html">表单验证</a>
                    </li>
                    <li><a class="J_menuItem" href="form_advanced.html">高级插件</a>
                    </li>
                    <li><a class="J_menuItem" href="form_wizard.html">表单向导</a>
                    </li>
                    <li>
                        <a href="#">文件上传 <span class="fa arrow"></span></a>
                        <ul class="nav nav-third-level">
                            <li><a class="J_menuItem" href="form_webuploader.html">百度WebUploader</a>
                            </li>
                            <li><a class="J_menuItem" href="form_file_upload.html">DropzoneJS</a>
                            </li>
                            <li><a class="J_menuItem" href="form_avatar.html">头像裁剪上传</a>
                            </li>
                        </ul>
                    </li>
                    <li>
                        <a href="#">编辑器 <span class="fa arrow"></span></a>
                        <ul class="nav nav-third-level">
                            <li><a class="J_menuItem" href="form_editors.html">富文本编辑器</a>
                            </li>
                            <li><a class="J_menuItem" href="form_simditor.html">simditor</a>
                            </li>
                            <li><a class="J_menuItem" href="form_markdown.html">MarkDown编辑器</a>
                            </li>
                            <li><a class="J_menuItem" href="code_editor.html">代码编辑器</a>
                            </li>
                        </ul>
                    </li>
                    <li><a class="J_menuItem" href="suggest.html">搜索自动补全</a>
                    </li>
                    <li><a class="J_menuItem" href="layerdate.html">日期选择器layerDate</a>
                    </li>
                </ul>
            </li>
            <li>
                <a href="#"><i class="fa fa-desktop"></i> <span class="nav-label">页面</span><span class="fa arrow"></span></a>
                <ul class="nav nav-second-level">
                    <li><a class="J_menuItem" href="contacts.html">联系人</a>
                    </li>
                    <li><a class="J_menuItem" href="profile.html">个人资料</a>
                    </li>
                    <li>
                        <a href="#">项目管理 <span class="fa arrow"></span></a>
                        <ul class="nav nav-third-level">
                            <li><a class="J_menuItem" href="projects.html">项目</a>
                            </li>
                            <li><a class="J_menuItem" href="project_detail.html">项目详情</a>
                            </li>
                        </ul>
                    </li>
                    <li><a class="J_menuItem" href="teams_board.html">团队管理</a>
                    </li>
                    <li><a class="J_menuItem" href="social_feed.html">信息流</a>
                    </li>
                    <li><a class="J_menuItem" href="clients.html">客户管理</a>
                    </li>
                    <li><a class="J_menuItem" href="file_manager.html">文件管理器</a>
                    </li>
                    <li><a class="J_menuItem" href="calendar.html">日历</a>
                    </li>
                    <li>
                        <a href="#">博客 <span class="fa arrow"></span></a>
                        <ul class="nav nav-third-level">
                            <li><a class="J_menuItem" href="blog.html">文章列表</a>
                            </li>
                            <li><a class="J_menuItem" href="article.html">文章详情</a>
                            </li>
                        </ul>
                    </li>
                    <li><a class="J_menuItem" href="faq.html">FAQ</a>
                    </li>
                    <li>
                        <a href="#">时间轴 <span class="fa arrow"></span></a>
                        <ul class="nav nav-third-level">
                            <li><a class="J_menuItem" href="timeline.html">时间轴</a>
                            </li>
                            <li><a class="J_menuItem" href="timeline_v2.html">时间轴v2</a>
                            </li>
                        </ul>
                    </li>
                    <li><a class="J_menuItem" href="pin_board.html">标签墙</a>
                    </li>
                    <li>
                        <a href="#">单据 <span class="fa arrow"></span></a>
                        <ul class="nav nav-third-level">
                            <li><a class="J_menuItem" href="invoice.html">单据</a>
                            </li>
                            <li><a class="J_menuItem" href="invoice_print.html">单据打印</a>
                            </li>
                        </ul>
                    </li>
                    <li><a class="J_menuItem" href="search_results.html">搜索结果</a>
                    </li>
                    <li><a class="J_menuItem" href="forum_main.html">论坛</a>
                    </li>
                    <li>
                        <a href="#">即时通讯 <span class="fa arrow"></span></a>
                        <ul class="nav nav-third-level">
                            <li><a class="J_menuItem" href="chat_view.html">聊天窗口</a>
                            </li>
                            <li><a class="J_menuItem" href="webim.html">layIM</a>
                            </li>
                        </ul>
                    </li>
                    <li>
                        <a href="#">登录注册相关 <span class="fa arrow"></span></a>
                        <ul class="nav nav-third-level">
                            <li><a href="login.html" target="_blank">登录页面</a>
                            </li>
                            <li><a href="login_v2.html" target="_blank">登录页面v2</a>
                            </li>
                            <li><a href="register.html" target="_blank">注册页面</a>
                            </li>
                            <li><a href="lockscreen.html" target="_blank">登录超时</a>
                            </li>
                        </ul>
                    </li>
                    <li><a class="J_menuItem" href="404.html">404页面</a>
                    </li>
                    <li><a class="J_menuItem" href="500.html">500页面</a>
                    </li>
                    <li><a class="J_menuItem" href="empty_page.html">空白页</a>
                    </li>
                </ul>
            </li>
            <li>
                <a href="#"><i class="fa fa-flask"></i> <span class="nav-label">UI元素</span><span class="fa arrow"></span></a>
                <ul class="nav nav-second-level">
                    <li><a class="J_menuItem" href="typography.html">排版</a>
                    </li>
                    <li>
                        <a href="#">字体图标 <span class="fa arrow"></span></a>
                        <ul class="nav nav-third-level">
                            <li>
                                <a class="J_menuItem" href="fontawesome.html">Font Awesome</a>
                            </li>
                            <li>
                                <a class="J_menuItem" href="glyphicons.html">Glyphicon</a>
                            </li>
                            <li>
                                <a class="J_menuItem" href="iconfont.html">阿里巴巴矢量图标库</a>
                            </li>
                        </ul>
                    </li>
                    <li>
                        <a href="#">拖动排序 <span class="fa arrow"></span></a>
                        <ul class="nav nav-third-level">
                            <li><a class="J_menuItem" href="draggable_panels.html">拖动面板</a>
                            </li>
                            <li><a class="J_menuItem" href="agile_board.html">任务清单</a>
                            </li>
                        </ul>
                    </li>
                    <li><a class="J_menuItem" href="buttons.html">按钮</a>
                    </li>
                    <li><a class="J_menuItem" href="tabs_panels.html">选项卡 &amp; 面板</a>
                    </li>
                    <li><a class="J_menuItem" href="notifications.html">通知 &amp; 提示</a>
                    </li>
                    <li><a class="J_menuItem" href="badges_labels.html">徽章，标签，进度条</a>
                    </li>
                    <li>
                        <a class="J_menuItem" href="grid_options.html">栅格</a>
                    </li>
                    <li><a class="J_menuItem" href="plyr.html">视频、音频</a>
                    </li>
                    <li>
                        <a href="#">弹框插件 <span class="fa arrow"></span></a>
                        <ul class="nav nav-third-level">
                            <li><a class="J_menuItem" href="layer.html">Web弹层组件layer</a>
                            </li>
                            <li><a class="J_menuItem" href="modal_window.html">模态窗口</a>
                            </li>
                            <li><a class="J_menuItem" href="sweetalert.html">SweetAlert</a>
                            </li>
                        </ul>
                    </li>
                    <li>
                        <a href="#">树形视图 <span class="fa arrow"></span></a>
                        <ul class="nav nav-third-level">
                            <li><a class="J_menuItem" href="jstree.html">jsTree</a>
                            </li>
                            <li><a class="J_menuItem" href="tree_view.html">Bootstrap Tree View</a>
                            </li>
                            <li><a class="J_menuItem" href="nestable_list.html">nestable</a>
                            </li>
                        </ul>
                    </li>
                    <li><a class="J_menuItem" href="toastr_notifications.html">Toastr通知</a>
                    </li>
                    <li><a class="J_menuItem" href="diff.html">文本对比</a>
                    </li>
                    <li><a class="J_menuItem" href="spinners.html">加载动画</a>
                    </li>
                    <li><a class="J_menuItem" href="widgets.html">小部件</a>
                    </li>
                </ul>
            </li>
            <li>
                <a href="#"><i class="fa fa-table"></i> <span class="nav-label">表格</span><span class="fa arrow"></span></a>
                <ul class="nav nav-second-level">
                    <li><a class="J_menuItem" href="table_basic.html">基本表格</a>
                    </li>
                    <li><a class="J_menuItem" href="table_data_tables.html">DataTables</a>
                    </li>
                    <li><a class="J_menuItem" href="table_jqgrid.html">jqGrid</a>
                    </li>
                    <li><a class="J_menuItem" href="table_foo_table.html">Foo Tables</a>
                    </li>
                    <li><a class="J_menuItem" href="table_bootstrap.html">Bootstrap Table
                            <span class="label label-danger pull-right">推荐</span></a>
                    </li>
                </ul>
            </li>
        </ul>
    </div>
</nav>
<!--左侧导航结束-->

<!--右侧部分开始-->
<div id="page-wrapper" class="gray-bg dashbard-1">
    <div class="row content-tabs">
        <button class="roll-nav roll-left J_tabLeft"><i class="fa fa-backward"></i>
        </button>
        <nav class="page-tabs J_menuTabs">
            <div class="page-tabs-content">
                <a href="javascript:;" class="active J_menuTab" data-id="<?php echo url('index/index'); ?>">首页</a>
            </div>
        </nav>
        <button class="roll-nav roll-right J_tabRight"><i class="fa fa-forward"></i>
        </button>
        <div class="btn-group roll-nav roll-right">
            <button class="dropdown J_tabClose" data-toggle="dropdown">关闭操作<span class="caret"></span>

            </button>
            <ul role="menu" class="dropdown-menu dropdown-menu-right">
                <li class="J_tabShowActive"><a>定位当前选项卡</a>
                </li>
                <li class="divider"></li>
                <li class="J_tabCloseAll"><a>关闭全部选项卡</a>
                </li>
                <li class="J_tabCloseOther"><a>关闭其他选项卡</a>
                </li>
            </ul>
        </div>
        <a href="<?php echo url('admins/logout'); ?>" class="roll-nav roll-right J_tabExit"><i class="fa fa fa-sign-out"></i> 退出</a>
    </div>
    <div class="row J_mainContent" id="content-main">
        <iframe class="J_iframe" name="iframe0" width="100%" height="100%" src="index_v2.html?v=4.0" frameborder="0" data-id="index_v2.html" seamless></iframe>
    </div>
    <div class="footer">
        <div class="pull-right">&copy; 2014-2015 <a href="http://www.zi-han.net/" target="_blank">zihan's blog</a>
        </div>
    </div>
</div>
<!--右侧部分结束-->
    
<!--mini聊天窗口开始-->
<div class="small-chat-box fadeInRight animated">

    <div class="heading" draggable="true">
        <small class="chat-date pull-right">
            2015.9.1
        </small> 与 Beau-zihan 聊天中
    </div>

    <div class="content">

        <div class="left">
            <div class="author-name">
                Beau-zihan <small class="chat-date">
                    10:02
                </small>
            </div>
            <div class="chat-message active">
                你好
            </div>

        </div>
        <div class="right">
            <div class="author-name">
                游客
                <small class="chat-date">
                    11:24
                </small>
            </div>
            <div class="chat-message">
                你好，请问H+有帮助文档吗？
            </div>
        </div>
        <div class="left">
            <div class="author-name">
                Beau-zihan
                <small class="chat-date">
                    08:45
                </small>
            </div>
            <div class="chat-message active">
                有，购买的H+源码包中有帮助文档，位于docs文件夹下
            </div>
        </div>
        <div class="right">
            <div class="author-name">
                游客
                <small class="chat-date">
                    11:24
                </small>
            </div>
            <div class="chat-message">
                那除了帮助文档还提供什么样的服务？
            </div>
        </div>
        <div class="left">
            <div class="author-name">
                Beau-zihan
                <small class="chat-date">
                    08:45
                </small>
            </div>
            <div class="chat-message active">
                1.所有源码(未压缩、带注释版本)；
                <br> 2.说明文档；
                <br> 3.终身免费升级服务；
                <br> 4.必要的技术支持；
                <br> 5.付费二次开发服务；
                <br> 6.授权许可；
                <br> ……
                <br>
            </div>
        </div>


    </div>
    <div class="form-chat">
        <div class="input-group input-group-sm">
            <input type="text" class="form-control"> <span class="input-group-btn"> <button
                        class="btn btn-primary" type="button">发送
                </button> </span>
        </div>
    </div>

</div>
<div id="small-chat">
    <span class="badge badge-warning pull-right">5</span>
    <a class="open-small-chat">
        <i class="fa fa-comments"></i>

    </a>

</div>

</body>
</html>