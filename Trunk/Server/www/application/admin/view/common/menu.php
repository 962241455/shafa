<!--左侧导航开始-->
<nav class="navbar-default navbar-static-side" role="navigation">
    <div class="nav-close"><i class="fa fa-times-circle"></i>
    </div>
    <div class="sidebar-collapse">
        <ul class="nav" id="side-menu">
            <li class="nav-header">
                <div class="dropdown profile-element">
                    <span class="title-logo"><img alt="image" class="img-circle" src="{:stamp('img/logo.png')}"/></span>
                    {if $admin}
                        <a data-toggle="dropdown" class="dropdown-toggle" href="#">
                        <span class="clear">
                        <span class="block m-t-xs"><strong class="font-bold">{$admin.name}</strong></span>
                        <span class="text-muted text-xs block">{$admin.name}<b class="caret"></b></span>
                        </span>
                    </a>
                    {/if}
                    <ul class="dropdown-menu animated fadeInRight m-t-xs">
                        <li><a class="J_menuItem" href="profile.html">个人资料</a></li>
                        <!--                        <li><a class="J_menuItem" href="contacts.html">联系我们</a></li>-->
                        <li class="divider"></li>
                        <li><a href="{:url('admins/logout')}">安全退出</a>
                        </li>
                    </ul>
                </div>
            </li>
            <li>
                <a href="{:url('index/index')}">
                    <i class="fa fa-home"></i>
                    <span class="nav-label">主页</span>
                </a>
            </li>
            {if $menudata}
                {foreach  name='$menudata' key='key' item='val'}
                    <li>
                        <a href="#"><i class="glyphicon glyphicon-{$val.icon}" aria-hidden="true"></i>
                            <span class="nav-label">{$val.desc}</span>
                            <span class="fa arrow"></span>
                        </a>
                        <ul class="nav nav-second-level">
                            {if $val.list}
                            {foreach name="$val.list" key="k" item="v"}
                                <li><a class="" href="{:url('index/input')}?action={$v.action}">{$v.desc}</a></li>
                            {/foreach}
                            {/if}
                        </ul>
                    </li>
                {/foreach}
            {/if}
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
                <a href="javascript:;" class="active J_menuTab" data-id="{:url('index/index')}">首页</a>
            </div>
        </nav>
        <a href="{:url('admins/logout')}" class="roll-nav roll-right J_tabExit"><i class="fa fa fa-sign-out"></i> 退出</a>
        <!--<button class="roll-nav roll-right J_tabRight"><i class="fa fa-forward"></i>
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
        </div>-->
    </div>

    <!--右侧部分结束-->