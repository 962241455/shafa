<?php

use yii\helpers\Html;
use yii\helpers\Url;
?>
<style type="text/css">
    a{
        text-decoration:none;
        color:#333;
    }
    /*手机*/
    @media screen and (max-width:600px){
        body{background-color: #EBEBEB};
        #content{width:90%;}
        .back{font-size: 10vw}
        .item{
            text-align: center;
            font-size: 5vw ;

        }

        .desc,.button{
            border: 1px solid ;
            border-color: gray;
            border-radius: 20px;
            padding: 10px 35px;
            font-size: 5vw;
            background: #FFF
        }
    }
    /*平板*/
    @media screen and (min-width:600px) and (max-width:960px){
        body{background-color: #EBEBEB};
        #content{width:90%;}
        .back{font-size: 10vw}
        .item{
            text-align: center;
            font-size: 3vw ;

        }
        .desc ,.button{
            border: 1px solid ;
            border-color: gray;
            border-radius: 30px;
            padding: 10px 35px;
            font-size: 3vw;
            background: #FFF
        }
    }
    /*PC*/
    @media screen and (min-width:960px){
        body{background-color: #EBEBEB};
        #content{width:100%;}
        .back{font-size: 10px}
        .item{  text-align: center;font-size: 10px
        }
        .desc ,.button{ border: 1px solid; border-color: gray;border-radius: 20px;padding: 10px 35px; font-size: 10px;background: #FFF
        }
    }
</style>
<div class="viewport">
    <!--    <div class="back"><a href="javascript:history.back();"><strong>&lt</strong></a>    -->
</div>
</br>
<div class="desc">
    <div class="title"><strong><?= $result['title'] ?></strong></div>
    <div>
        <p> <?= date("Y年m月d日 H:i:s", $result['send_time']) ?></p>
    </div>
    <div class="rule">
        <p><?= $result['content'] ?></p>
        <HR style="FILTER: alpha(opacity=100,finishopacity=0,style=3)" width="100%"  SIZE=3>
        <div class='close'>
            <?php if ($result['read_flag'] == 1): ?><div class="item">已确认</div><?php else : ?>
                <input type="hidden" class="id" value="<?= $result['guid'] ?>">
                <input type="hidden" class="uid" value="<?= $uid ?>">
                <input type="hidden" class="token" value="<?= $token ?>">
                <input class="button" type="button" value='确认'  style="background-color: greenyellow">&nbsp;&nbsp;&nbsp;&nbsp;
                <input class="button" type="button" value='拒绝'  style="background-color: greenyellow"><?php endif; ?>

        </div>
    </div>
</div>
</div>
<script src="jquery.min.js" type="text/javascript"></script>
<script>
    $(".button").click(function () {
        $.ajax({
            type: "get",
            url: '/index.php?r=site/read',
            data: {'id': $(".id").val(), 'uid': $(".uid").val(), 'token': $(".token").val()}, // 你的formid
            dataType: 'html',
            success: function (data) {
                $(".close").html('已确认')
            }
        });
    })
</script>

