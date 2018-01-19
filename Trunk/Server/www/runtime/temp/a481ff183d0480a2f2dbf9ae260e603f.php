<?php if (!defined('THINK_PATH')) exit(); /*a:2:{s:101:"D:\phpStudy\WWW\chengwang\mix_App\Trunk\Server\www\public/../application/index\view\notice\detail.php";i:1516354092;s:84:"D:\phpStudy\WWW\chengwang\mix_App\Trunk\Server\www\application\index\view\layout.php";i:1516346260;}*/ ?>
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

        <div class="layui-row layui-col-space15">
            <div class="layui-col-md12 content detail">
                <?php if($data['code'] == 0): ?>
                    <div class="fly-panel detail-box">
                        <h2><?php echo $data['result']['title']; ?></h2>
                        <div class="fly-detail-info">
                            <?php echo date("Y年m月d日 H:i:s", $data['result']['send_time']); ?>
                        </div>
                    </div>

                    <div class="fly-panel detail-box">
                        <pre class="div-conent-text"><?php echo $data['result']['content']; ?>
</pre>
                    </div>

                    <?php if($data['result']['read_flag'] != 1): ?>
                        <input type="hidden" class="id" value="<?php echo $data['result']['guid']; ?>">
                        <input type="hidden" class="uid" value="<?php echo $form['uid']; ?>">
                        <input type="hidden" class="token" value="<?php echo $form['token']; ?>">
                    <?php endif; else: ?>
                    <div class="layui-elem-quote fly-none">
                        <div><?php echo !empty($data['message'])?$data['message']:"暂无消息内容"; ?></div>
                    </div>
                <?php endif; ?>
            </div>

        </div>

    </div>
</div>
<script>
    function statusRead() {
        var id = $(".id").val();
        var uid = $(".uid").val();
        var token = $(".token").val();
        if (id && uid && token) {
            $.ajax({
                type: "post",
                url: '<?php echo url("notice/read"); ?>',
                data: {'id': id, 'uid': uid, 'token': token},
                dataType: 'json',
                success: function (data) {
                    console.log(data)
                }
            });
        }
    }

    statusRead()
</script>

</div>

</body>
</html>