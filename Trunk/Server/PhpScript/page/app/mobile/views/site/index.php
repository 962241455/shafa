<?php
$this->title = '通知';
?>

<div class="layui-box">
    <div class="layui-container padding-none">

        <div class="layui-row">
            <div class="layui-tab-brief">
                <div class="">
                    <?php
                    if ($code == 0): ?>
                        <?php if ($result): ?>
                            <?php foreach ($result as $v): ?>
                                <ul class="mine-msg">
                                    <li onclick="urlJump('<?= WEB_URL ?>','<?= $v["guid"] ?>', '<?= $uid ?>', '<?= $token ?>' )">
                                        <blockquote class="layui-elem-quote">
                                            <b><?= $v['title'] ?></b>
                                            <span class="li-span"><?= date("Y年m月d日 H:i:s", $v['send_time']) ?></span>
                                            <?php if ($v['read_flag']): ?>
                                                <i class="li-inco li-inco-color"></i>
                                            <?php else: ?>
                                                <i class="li-inco"></i>
                                            <?php endif; ?>
                                            <div class="div-text">
                                                <?php if ($v['summary']): ?>
                                                    <?= $v['summary'] ?>
                                                <?php else: ?>
                                                    <?php echo mb_substr($v['content'], 0, 80) ?>
                                                <?php endif; ?>
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
                            <?php endforeach; ?>
                        <?php else : ?>
                            <div class="layui-elem-quote fly-none">
                                <div>您暂时没有最新消息</div>
                            </div>
                        <?php endif; ?>
                    <?php else : ?>
                        <div class="layui-elem-quote fly-none">
                            <div><?= $message ?></div>
                        </div>
                    <?php endif; ?>
                </div>
            </div>

        </div>
    </div>
</div>

<script>
    function urlJump(host, guid, uid, token) {
        var url = "/index.php?r=site/detail&id=" + guid + "&uid=" + uid + "&token=" + token
        window.location.href = url
    }
</script>