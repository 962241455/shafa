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
class Log_account extends \yii\db\ActiveRecord
{
    /**
     * @inheritdoc
     */
    public static function tableName()
    {
        return '{{%log_account}}';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            [['guid','uid'], 'integer'],
//            [['username',], 'string', 'max' => 20],
//            [['password'], 'string', 'max' => 32],
//            [['encrypt'], 'string', 'max' => 6],
//            [['lastloginip'], 'string', 'max' => 15],
//            [['email'], 'string', 'max' => 40],
//            [['realname'], 'string', 'max' => 50]
        ];
    }

    /**
     * @inheritdoc
     */
    public function attributeLabels()
    {
        return [
            'userid' => Yii::t('admin', 'Userid'),
            'username' => Yii::t('admin', 'Username'),
            'password' => Yii::t('admin', 'Password'),
            'roleid' => Yii::t('admin', 'Roleid'),
            'encrypt' => Yii::t('admin', 'Encrypt'),
            'lastloginip' => Yii::t('admin', 'Lastloginip'),
            'lastlogintime' => Yii::t('admin', 'Lastlogintime'),
            'email' => Yii::t('admin', 'Email'),
            'realname' => Yii::t('admin', 'Realname'),
        ];
    }
}
