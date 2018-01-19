<?php

use yii\helpers\Html;
use app\assets\AppAsset;

AppAsset::register($this);
//AppAsset::addCss($this,'/css/main.css');

?>

<?php $this->beginPage() ?>
    <!DOCTYPE html>
    <html>
    <head lang="zh">
        <meta charset="<?= Yii::$app->charset ?>"/>
        <meta name="viewport"
              content="width=device-width,initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no"/>
        <meta name="format-detection" content="telephone=no"/>
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