<?php
$this->title = '通知详情';
?>
<div class="layui-box">
    <div class="layui-container padding-none">

        <div class="layui-row layui-col-space15">
            <div class="layui-col-md12 content detail">
                <div class="fly-panel detail-box">
                    <h2><?= $result['title'] ?></h2>
                    <div class="fly-detail-info">
                        <?= date("Y年m月d日 H:i:s", $result['send_time']) ?>
                    </div>
                </div>

                <div class="fly-panel detail-box">
                    <pre class="div-conent-text"><?= $result['content'] ?>
</pre>
                </div>

                <?php if ($result['read_flag'] != 1): ?>
                    <input type="hidden" class="id" value="<?= $result['guid'] ?>">
                    <input type="hidden" class="uid" value="<?= $uid ?>">
                    <input type="hidden" class="token" value="<?= $token ?>">
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
        if(id && uid && token) {
            $.ajax({
                type: "get",
                url: '/index.php?r=site/read',
                data: {'id': id, 'uid': uid, 'token': token}, // 你的formid
                dataType: 'json',
                success: function (data) {
                    console.log(data)
                }
            });
        }

    }

    statusRead()
</script>

