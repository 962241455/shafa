<?php

namespace common\models;

use Yii;

/**
 * This is the model class for table "{{%admin}}".
 *
 * @property string $userid
 * @property string $username
 * @property string $password
 * @property integer $roleid
 * @property string $encrypt
 * @property string $lastloginip
 * @property string $lastlogintime
 * @property string $email
 * @property string $realname
 */
class Message extends \yii\db\ActiveRecord {

    /**
     * @inheritdoc
     */
    public static function tableName() {
        return '{{%message}}';
    }

    public static function getDb() {
        return \yii::$app->get('db1');
    }

    /**
     * @inheritdoc
     */
    public function rules() {
        return [
           [['uid','id','addtime'], 'integer'],
            [['title'], 'safe'],
           [['content'], 'safe'],
             [['note'], 'safe'],
        ];
    }

    /**
     * @inheritdoc
     */
    public function attributeLabels() {
        return [
            'uid' => '用户账号',
            'addtime' => '通知时间',
        ];
    }

}
