<?php if (!defined('THINK_PATH')) exit(); /*a:2:{s:100:"D:\phpStudy\WWW\chengwang\mix_App\Trunk\Server\www\public/../application/index\view\notice\index.php";i:1516351578;s:84:"D:\phpStudy\WWW\chengwang\mix_App\Trunk\Server\www\application\index\view\layout.php";i:1516346260;}*/ ?>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport"
          content="width=device-width,initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no"/>
    <meta name="format-detection" content="telephone=no"/>
    <meta name="renderer" content="webkit">
    <meta http-equiv="Cache-Control" content="no-siteapp"/>
    <title><?php echo $title; ?></title>
    <meta name="keywords" content="">
    <meta name="description" content="">

    <!--[if lt IE 8]>
    <meta http-equiv="refresh" content="0;ie.html"/>
    <![endif]-->
    <link type="text/css" rel="stylesheet" href="<?php echo stamp('index/css/addone.css'); ?>"/>
    <link type="text/css" rel="stylesheet" href="<?php echo stamp('index/css/layui.css'); ?>"/>
    <script src="<?php echo stamp('js/jquery.min.js'); ?>"></script>
    <script src="<?php echo stamp('index/js/layui.js'); ?>"></script>
</head>

<body >
<div id="wrapper">
    

<div class="layui-box">
    <div class="layui-container padding-none">
        <div class="layui-row">
            <div class="layui-tab-brief">
                <div class="">
                    <?php if($data['code'] == 0): if($data['result']): foreach($data['result'] as $v): ?>
                            <ul class="mine-msg">
                                <li onclick="window.location.href='<?php echo url("notice/detail"); ?>?id=<?php echo $v['guid']; ?>&uid=<?php echo $form['uid']; ?>&token=<?php echo $form['token']; ?>'">
                                    <blockquote class="layui-elem-quote">
                                        <b><?php echo $v['title']; ?></b>
                                        <span class="li-span"><?php echo date("Y年m月d日 H:i:s", $v['send_time']); ?></span>
                                        <?php if($v['read_flag']): ?>
                                            <i class="li-inco li-inco-color"></i>
                                        <?php else: ?>
                                            <i class="li-inco"></i>
                                        <?php endif; ?>
                                        <div class="div-text">
                                            <?php if($v['summary']): ?>
                                                <?php echo $v['summary']; else: ?>
                                                <?php echo mb_substr($v['content'],0,50,'utf-8'); endif; ?>
                                        </div>
                                    </blockquote>
                                </li>
                                <!--<li data-id="123">
                                    <blockquote class="layui-elem-quote">
                                        <b>系统消息：欢</b>
                                        <span class="li-span">1小时前</span>
                                        <i class="li-inco"></i>
                                        <div class="div-text">
                                            载解压后，放置 localhost 首先打开下运行.载解压后，放置 localho载解压后，放置 localho
                                        </div>
                                    </blockquote>
                                </li>-->
                            </ul>
                    <?php endforeach; else: ?>
                        <div class="layui-elem-quote fly-none">
                            <div>您暂时没有最新消息</div>
                        </div>
                    <?php endif; else: ?>
                        <div class="layui-elem-quote fly-none">
                            <div><?php echo $data['message']; ?></div>
                        </div>
                    <?php endif; ?>
                </div>
            </div>

        </div>
    </div>
</div>


</div>

</body>
</html>