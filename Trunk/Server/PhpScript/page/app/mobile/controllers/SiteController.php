<?php

namespace app\controllers;

use Yii;
use yii\filters\AccessControl;
use yii\filters\VerbFilter;
use yii\helpers\Url;
use yii\helpers\Json;
use \common\util\Helper;

class SiteController extends \yii\web\Controller {

    public function actionIndex() {
       echo phpinfo();
    }

//系统通知
    public function actionMail() {
        $uid = (int) \Yii::$app->getRequest()->get('uid', 0);
        $token = \Yii::$app->getRequest()->get('token', 0);
        $url = WEB_SOFA . '?action=GetSysNotice&uid=' . $uid . '&token=' . $token;
        $data = json_decode(Helper::http_get($url), TRUE);
        $data['uid'] = $uid;
        $data['token'] = $token;
        //var_dump(Helper::http_get($url));exit;
        return $this->render('index', $data);
    }

//系统通知详情页面
    public function actionDetail() {
        $id = (int) \Yii::$app->getRequest()->get('id', 0);
        // var_dump($id);exit;
        $uid = (int) \Yii::$app->getRequest()->get('uid', 0);
        $token = \Yii::$app->getRequest()->get('token', 0);
        if ($id) {
            $url = WEB_SOFA . '?action=GetOneMail&uid=' . $uid . '&token=' . $token . '&guid=' . $id;
        }
        $data = json_decode(Helper::http_get($url), TRUE);
        $data['uid'] = $uid;
        $data['token'] = $token;
        //var_dump($data);exit;
        return $this->render('detail', $data);
    }

    public function actionRead() {
        $id = (int) \Yii::$app->getRequest()->get('id', 0);
        // var_dump($id);exit;
        $uid = (int) \Yii::$app->getRequest()->get('uid', 0);
        $token = \Yii::$app->getRequest()->get('token', 0);
        $urlpost = WEB_SOFA . '?action=ReadMailTag&uid=' . $uid . '&token=' . $token . '&mail_id=' . $id . '&read_flag=1';

        $ddd = Helper::vcurl($urlpost);

        return $ddd;
    }

}
