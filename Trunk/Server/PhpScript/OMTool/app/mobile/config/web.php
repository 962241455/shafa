<?php

$config = [
    'id' => 'mobile',
    'basePath' => dirname(__DIR__),
    'vendorPath' => VENDOR_PATH,
    'timeZone' => 'Asia/Shanghai',
    //'bootstrap' => ['log'],
    'aliases' => [
        '@common' => PROJECT_PATH . '/common'
    ],
    'components' => [
        'request' => [
            // !!! insert a secret key in the following (if it is empty) - this is required by cookie validation
            'cookieValidationKey' => 'HELLO',
            'enableCookieValidation' => true,
            'enableCsrfValidation' => false,
        ],
        'cache' => [
            'class' => 'yii\caching\FileCache',
        ],
     
        'user' => [
            //'identityClass' => '',
            'identityClass' => 'app\models\User',
            'enableAutoLogin' => false,
        ],
        'urlManager' => [
            'enablePrettyUrl' => false,
            'showScriptName' => false,
            'rules' => [
            //['class'=>'yii\rest\UrlRule','controller'=>'site'],
            ],
        ],
        'errorHandler' => [
            'errorAction' => 'site/error',
        ],
        'mailer' => [
            'class' => 'yii\swiftmailer\Mailer',
            // send all mails to a file by default. You have to set
            // 'useFileTransport' to false and configure a transport
            // for the mailer to send real emails.
            'useFileTransport' => true,
        ],
        'log' => [
            'traceLevel' => YII_DEBUG ? 3 : 0,
            'targets' => [
                [
                    'class' => 'yii\log\FileTarget',
                    'levels' => ['error', 'warning'],
                ],
            ],
        ],
        'db' => [
            'class' => 'yii\db\Connection',
            'dsn' => 'mysql:host=192.168.8.34;dbname=mixlog',
            //'dsn' => 'mysql:host=192.168.10.99;dbname=cqdx_hdzq',
            'username' => 'root',
            'password' => '123456',
            'charset' => 'utf8',
            'tablePrefix' => 'tbl_',
    ],
         'db1' => [
            'class' => 'yii\db\Connection',
            'dsn' => 'mysql:host=localhost;dbname=mixlog',
            'username' => 'root',
            'password' => '123456',
            'charset' => 'utf8',
            'tablePrefix' => 'tbl_',
        ],
    
    ],
    'modules' => [
    ],
    'params' => require(PROJECT_PATH . '/common/config/params.php'),
];

if (YII_ENV_DEV) {
    // configuration adjustments for 'dev' environment
    $config['bootstrap'][] = 'debug';
    $config['modules']['debug'] = 'yii\debug\Module';

    $config['bootstrap'][] = 'gii';
    $config['modules']['gii'] = 'yii\gii\Module';
}

return $config;
