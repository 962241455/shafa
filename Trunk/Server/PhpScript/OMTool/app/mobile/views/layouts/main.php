<?php

use yii\helpers\Html;
use app\assets\AppAsset;

AppAsset::register($this);

?>

<?php $this->beginPage() ?><!DOCTYPE html>
    <!DOCTYPE html>
    <!--[if IE 8]> <html lang="zh" class="ie8 no-js"> <![endif]-->
    <!--[if IE 9]> <html lang="zh" class="ie9 no-js"> <![endif]-->
    <head lang="zh">
        <meta charset="<?= Yii::$app->charset ?>"/>
        <meta name="format-detection" content="telephone=no"/>
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
        <meta http-equiv="Content-type" content="text/html; charset=utf-8">
        <meta content="" name="description"/>
        <meta content="" name="author"/>
        <?= Html::csrfMetaTags() ?>
        <title><?= Html::encode($this->title) ?></title>
        <?php $this->head() ?>
    </head>
    <body>
    <?php $this->beginBody() ?>
    <?= $content ?>
    <?php $this->endBody() ?>
    </body>

    </html>
<?php $this->endPage() ?>