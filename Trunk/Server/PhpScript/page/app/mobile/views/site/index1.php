
<div class="viewport" id="content">
    <!--    <div class="back"><a href="javascript:history.back();">&LT;</a></div>-->
    <?php if ($code == 0): ?>
        <?php if ($result): ?>
            <?php foreach ($result as $v): ?>
                <div class="item" > <?= date("Y年m月d日 H:i:s", $v['send_time']) ?></div>
                &nbsp;
                <div class="desc" border="">
                    <strong><?= $v['title'] ?></strong>
                    <p><?= $v['summary'] ?></p>
                    <?php if ($v['content']): ?>
                        <HR style="FILTER: alpha(opacity=100,finishopacity=0,style=3)" width="100%"  SIZE=3>
                        <a href="<?= WEB_URL . '/index.php?r=site/detail&id=' . $v['guid'] . '&uid=' . $uid . '&token=' . $token ?>">查看详情 ></a>
                    <?php else : ?>
                        <HR style="FILTER: alpha(opacity=100,finishopacity=0,style=3)" width="100%"  SIZE=3>
                        <div class='close'>
                            <?php if ($v['read_flag'] == 1): ?><div class="item">已确认</div><?php else : ?>
                                <input type="hidden" class="id" value="<?= $v['guid'] ?>">
                                <input type="hidden" class="uid" value="<?= $uid ?>">
                                <input type="hidden" class="token" value="<?= $token ?>">
                                <input class="button" type="button" value='确认'  style="background-color: greenyellow">&nbsp;&nbsp;&nbsp;&nbsp;
                                <input class="button" type="button" value='拒绝'  style="background-color: greenyellow"><?php endif; ?>
                        </div>
                    <?php endif; ?>
                </div>
                </br> </br>  </br>
            <?php endforeach; ?>
        <?php else : ?>
            <div class="item">暂无系统通知...</div>
        <?php endif; ?>
    <?php else : ?>
        <div class="item"><?= $message ?></div>
    <?php endif; ?>
</div>
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