<?php

use yii\helpers\Html;
use yii\helpers\Url;
?>

<div id="dht">
    <p>欢迎登录GM后台指令操作</p>
    <li>
        <a href="/index.php?r=site/index">
            <i class="icon-logout"></i> 退出 </a>
    </li>
    <button class="modify">
        修改密码 
    </button>
    <div class="pass">
        <form action='/index.php?r=site/menu' method='post'>
            <input type='hidden' id='hidden' name='action' value='GMModPwd'>
            修改密码：<input type='text'name='pass'>&nbsp;
            <button class='submit' type='button'>确认</button>
        </form>
    </div>
</div>
<div id="cddh"> 
    <ul>

        <?php foreach ($result as $key => $v) :
            ?> 
            <li class="btn" data_id="<?= WEB_URL . '/index.php?r=site/menu&action=' . $v['url'] . "&arg=" . $v['args'] . "&subact=" . $v['subAct'] ?>"><?= $v['desc'] ?></li></br>   
        <?php endforeach; ?>
    </ul>
</div>


<div id="ztnr" >登录GM账号：<?= $list['name'] ?></br>GM指令power：<?= $list['power'] ?>
</div>
<div id="user"></div>
<script>
    $("#dht").click(function () {
        var html = '登录GM账号：<?= $list['name'] ?></br>GM指令power：<?= $list['power'] ?>'
        $("#ztnr").html(html)
    })
    $("#cddh ul li").click(function () {
        $("#user").html('')
        var url = $(this).attr("data_id");
        $(this).addClass("checked").siblings().removeClass("checked");
        $.ajax({
            type: 'get',
            url: url,
            dataType: 'html',
            success: function (html) {
                $("#ztnr").html(html)
                // console.log($("#ztnr").find("button").val())
                $(".submitAdd").click(function () {
                    if ($(".hidden").val() == 'QueryUser') {
                        var datajson = 'html';
                    } else {
                        var datajson = 'json';
                    }
//                     alert($(".hidden").val())
                    var ajaxUrl = '/index.php?r=site/menu';
                    $.ajax({
                        type: "POST",
                        url: ajaxUrl,
                        data: $('form').serialize(), // 你的formid
                        dataType: datajson,
                        error: function (request) {
                            alert("Connection error");
                        },
                        success: function (data) {

                            if (data.msg) {
                                alert(data.msg)
                                window.location.reload();
                            } else {
                                $("#user").html(data)
                                
                                $(".data").bind("change", function () {
                                    var subact = $(this).val();
                                    alert(subact)
                                    var ajaxUrl = '/index.php?r=site/chlid';
                                    $.ajax({
                                        type: "get",
                                        url: ajaxUrl,
                                        data: {'subact': subact},
                                        dataType: 'json',
                                        error: function (request) {
                                            alert("Connection error");
                                        },
                                        success: function (data) {
                                            console.log(data)
                                        }
                                    });

                                })
                            }
                        }
                    });
                })

                $(".data").bind("change", function () {
                    var subact = $(this).val();
                    alert(subact)
                    var ajaxUrl = '/index.php?r=site/chlid';
                    $.ajax({
                        type: "get",
                        url: ajaxUrl,
                        data: {'subact': subact},
                        dataType: 'json',
                        error: function (request) {
                            alert("Connection error");
                        },
                        success: function (data) {
                            console.log(data)
                        }
                    });

                })

            }
        })

    })

    $(".modify").click(function () {
        $(".pass").show()
    })
    $(".submit").click(function () {
        var ajaxUrl = '/index.php?r=site/menu';
        $.ajax({
            type: "POST",
            url: ajaxUrl,
            data: $('form').serialize(), // 你的formid
            dataType: 'json',
            error: function (request) {
                alert("Connection error");
            },
            success: function (data) {
                $(".pass").hide()
                if (data.msg) {
                    alert(data.msg)
                    window.location.reload();
                }
            }
        });
    })

</script>

