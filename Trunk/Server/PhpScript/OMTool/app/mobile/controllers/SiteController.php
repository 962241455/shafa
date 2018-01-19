<?php

namespace app\controllers;

$session = \yii::$app->session;
$session->set("uid", 1111);

use Yii;
use yii\filters\AccessControl;
use yii\filters\VerbFilter;
use yii\helpers\Url;
use yii\helpers\Json;
use common\models\Log_charge;
use common\models\Log_normal;
use common\models\Charge_log;
use common\models\Log_share;
use common\models\Log_account;
use common\models\Log;
use common\models\Message;
use \common\util\Helper;

class SiteController extends \yii\web\Controller {

//登录GM账号界面
    public function actionIndex() {
        $action = "AddGM";
        $name = "admin";
        $pass = "123456";
        $data = $this->Getdata($action, $name, $pass);
//        var_dump($data);
        return $this->render('login');
    }

    public function actionAdmin() {
        //var_dump($_SESSION);exit;
        return $this->render('admin', $_SESSION['data']);
    }

    //登录成功欢迎界面
    public function actionLogin() {
        $session = \yii::$app->session;
        if (Yii::$app->request->post()) {
            // var_dump($_POST);exit;
            $action = $_POST['action'];
            $name = $_POST['LoginForm']['username'];
            $pass = $_POST['LoginForm']['password'];
            $data = $this->Getdata($action, $name, $pass);
            // var_dump($data['result']['gmList']);exit;
            $model = [];
            $args = [];
            if ($data['code'] == 0) {
                $list['list'] = $data['result']['gmInfo'];
                $session->set('mes', $data['result']['gmInfo']);
                //  var_dump($data['result']['gmList']);exit;
                foreach ($data['result']['gmList'] as $k => &$value) {
                    $value['url'] = $k;
                    if (isset($value['subAct'])) {
                        $value['subAct'] = implode(',', $value['subAct']);
                    } else {
                        $value['subAct'] = '';
                    }
                    $value['args'] = implode(',', $value['args']);
                    $model['result'][] = $value;
                }

                $datalist = array_merge($list, $model);
                $ajaxRet = array(
                    'status' => 1,
                    'msg' => $data['message'],
                );
                $session->set('data', $datalist);
                // return $this->render('admin', $datalist);
            } else {
                $ajaxRet = array(
                    'status' => 0,
                    'msg' => $data['message'],
                );
            }
            return Json::encode($ajaxRet);
        }
    }

//根据数据自动生成页面
    public function actionMenu() {

        $subact = \Yii::$app->getRequest()->get('subact', '');
        
        if (Yii::$app->request->post()) {
            //  var_dump($_POST);exit;
            $args = '';
            foreach ($_POST as $key => $value) {
                if ($key != 'action') {
                    $args .= "&$key=$value";
                }
            }

            // var_dump($subact);exit; 
            $action = $_POST['action'];
            $name = $_SESSION['mes']['name'];
            $token = $_SESSION['mes']['token'];
            if (strpos($args, ',') == FALSE) {
                $data = $this->Getdata($action, $name, '', $token, $args);
            } else {
                $data = 1;
            }

            $html = '';
            $htmldata = '';
            $htmlselect='';
            if ($data['code'] == 0) {
                //  var_dump($data);exit;
                if ($action == 'QueryUser') {
                           if ($_POST['subact']) {
                               $data['result']['subAct']['subact']=explode(',', $_POST['subact']);
                        foreach (explode(',', $_POST['subact']) as $key => $value) {
                            $htmlselect.= "<option value='$value' >$value</option>";
                        }
                    }               
                    foreach ($data['result'] as $k => $row) {
                        $html.="<td>'$k'</td> ";
                            if (!isset($row['subact'])) {
 
                                $htmldata.="<td>'$row'</td>";
                            } else {
                                $htmldata.="<td><select name='option' class='data'><option>请选择</option>$htmlselect</select></td>";
                            }
                    }

                    return "<table width='300' border='1px' cellspacing='0'><tr>" . $html . "</tr><tr>" . $htmldata . "</tr></table>";
                } else {
                    $ajaxRet = array(
                        'status' => 1,
                        'msg' => $data['message'],
                    );
                    //  echo  $html;exit;
                    return Json::encode($ajaxRet);
                }
            } else {
                $ajaxRet = array(
                    'status' => 0,
                    'msg' => $data['message'],
                );
                //  echo  $html;exit;
                return Json::encode($ajaxRet);
            }
        } else {
            $action = \Yii::$app->getRequest()->get('action', 0);
            $name = $_SESSION['mes']['name'];
            $token = $_SESSION['mes']['token'];
            $args = \Yii::$app->getRequest()->get('arg', '');
            $htmldata = '';
            $htmldatas = '';
            $html = '';
            $htmlselect = '';
            $html1 = '';
            if ($args) {
                $args = explode(',', $args);
                foreach ($args as $value) {
                    if ($value == "content") {
                        $html.="<div ><lable>$value</lable>:&nbsp;&nbsp;<script id='container' name='$value' type='text/plain' style='height: 300px'>$value</script></div></br>";
                    }else{
                        $html.="<div ><lable>$value</lable>:&nbsp;&nbsp;<input type='text'value=''placeholder='$value' name='$value'></input> </div></br>";
                    }
                }
                //action='/index.php?r=site/menu' method='post'
                $textHtml = <<<EOD
                    <div class='gmdiv'>
                        <form id='login-form' > 
                            <input type='hidden' class='hidden' name='action' value='$action'>
                            <input type='hidden'  name='subact' value='$subact'>
                            <h3 class='form-title'></h3>
                             $html
                            <div>
                                <button  class='submitAdd' type='button' value='tdd' >提交</button>
                            </div>
                        </form>
                    </div>
                    <script>
                        var ue = UE.getEditor('container');
                    </script>
EOD;
                return $textHtml;
            } else {
                $data = $this->Getdata($action, $name, '', $token, $args);

                if ($data['code'] == 0) {
                    if ($subact) {
                        foreach ($data['result'] as $k => &$row) {
                            $row['subAct']['subact'] = explode(',', $subact);
                        }
                        foreach (explode(',', $subact) as $key => $value) {
                            $htmlselect.= "<option value='$value' >$value</option>";
                        }
                    }

                    foreach ($data['result'][0] as $key => $val) {
                        $html1.="<td>'$key'</td> ";
                    }
                    for ($i = 0; $i < count($data['result']); $i++) {
                        foreach ($data['result'][$i] as $keys => $value) {
                            if (!isset($value['subact'])) {
                                //  echo 111;
                                $htmldata.="<td>'$value'</td>";
                            } else {
                                $htmldata.="<td><select name='option' class='data' args='fff'><option>请选择</option>$htmlselect</select></td>";
                            }
                        }
                        $htmldata = "<tr>$htmldata</tr>";
                    }
                    echo "<table width='300' border='1px' cellspacing='0'><tr>" . $html1 . "</tr>" . $htmldata . "</table>";
                }
            }
        }
    }
//子指令的处理
    public function actionChlid() {
         $subact = \Yii::$app->getRequest()->get('subact', '');
         if($subact){
            
         }
         $ajaxRet = array(
                    'status' => 0,
                    'msg' => 222,
                );
        return json_encode($ajaxRet);
    }
//获取服务器上的数据
    public function Getdata($action, $name, $pass = null, $token = null, $args = null) {
        $url = WEB_GM . '?action=' . $action . '&gmName=' . $name . '&gmPass=' . $pass . '&gmToken=' . $token . $args;
        $data = json_decode(Helper::http_get($url), TRUE);

        return $data;
    }

    public function actionSendmail() {
        //系统发送邮件
        $urlpo = WEB_SOFA . '?action=AddUserFeedBack&token=' . 94121150 . '&uid=' . 7 .
                '&title=' . '测试' . '&summary=' . '测试系统通知样式' . '&content=' . '测试测试时尚' . '&attachment=' . '';
        $data = Helper::vcurl($urlpo);
        //var_dump($data);exit;
        $reslut = json_decode($data, TRUE);
        $ajax = ['code' => 1, 'message' => 'error'];
        if ($reslut['code'] == 0) {
            return $data;
        } else {
            return json_encode($ajax);
        }
    }

    /**
     * 充值log记录接口
     */
    public function insertLog($where, $payway, $pid, $platID, $time) {
        $number = Log_charge::find()->where($where)->count(); //充值次数
        $person = Log_charge::find()->where($where)->groupBy('uid')->count(); //充值人数
        $amount = Log_charge::find()->where($where)->sum('amount'); //充值总金额
        $sqlstr = "('" . $time . "','" . $platID . "','" . $payway . "','" . $pid . "','" . $number . "','" . $person . "','" . $amount . "')";
        \Yii::$app->db->createCommand('INSERT INTO ' . Charge_log::tableName() . ' (`record_time`,`platID`,`payway`,`pid`,`pay_count`,`user_count`,`total_amount`) VALUES ' . $sqlstr)->execute();
    }

    public function actionCharge() {
//        if(isset($_GET['ajax']) && $_GET['ajax']=="list"){
        $dayTime = strtotime(date("Y-m-d", strtotime("-1 day", time())));
        $dayUpTime = $dayTime + 24 * 3600;
        $where = "createTime>=$dayTime and createTime<=$dayUpTime ";
        $data = Log_charge::find()->select('guid,platID,createTime,pid,amount,payway')->where($where)->all();
        //var_dump($data);
        // exit;
        $time = date("Y-m-d", strtotime("-1 day", time()));
        foreach ($data as $key => $value) {
            if (!$value['platID']) {
                if ($value['payway'] == 1) {
                    if ($value['pid'] == 'p1') {
                        $this->insertLog("payway=1 and pid='p1' and !platID", 1, 'p1', 0, $time);
                    }
                    if ($value['pid'] == 'p2') {
                        $this->insertLog("payway=1 and pid='p2' and !platID", 1, 'p2', 0, $time);
                    }
                    if ($value['pid'] == 'p3') {
                        $this->insertLog("payway=1 and pid='p3' and !platID", 1, 'p3', 0, $time);
                    }
                    if ($value['pid'] == 'p4') {
                        $this->insertLog("payway=1 and pid='p4' and !platID", 1, 'p4', 0, $time);
                    }
                    if ($value['pid'] == 'p5') {
                        $this->insertLog("payway=1 and pid='p6' and !platID", 1, 'p5', 0, $time);
                    }
                    if ($value['pid'] == 'p6') {
                        $this->insertLog("payway=1 and pid='p6' and !platID", 1, 'p6', 0, $time);
                    }
                }
                if ($value['payway'] == 2) {
                    if ($value['pid'] == 'p1') {
                        $this->insertLog("payway=2 and pid='p1' and !platID", 2, 'p1', 0, $time);
                    }
                    if ($value['pid'] == 'p2') {
                        $this->insertLog("payway=2 and pid='p2' and !platID", 2, 'p2', 0, $time);
                    }
                    if ($value['pid'] == 'p3') {
                        $this->insertLog("payway=2 and pid='p3' and !platID", 2, 'p3', 0, $time);
                    }
                    if ($value['pid'] == 'p4') {
                        $this->insertLog("payway=2 and pid='p4' and !platID", 2, 'p4', 0, $time);
                    }
                    if ($value['pid'] == 'p5') {
                        $this->insertLog("payway=2 and pid='p5' and !platID", 2, 'p5', 0, $time);
                    }
                    if ($value['pid'] == 'p6') {
                        $this->insertLog("payway=2 and pid='p6' and !platID", 2, 'p6', 0, $time);
                    }
                }
            };
            if ($value['platID'] == 1) {
                if ($value['payway'] == 1) {
                    if ($value['pid'] == 'p1') {
                        $this->insertLog("payway=1 and pid='p1' and platID=1", 1, 'p1', 1, $time);
                    }
                    if ($value['pid'] == 'p2') {
                        $this->insertLog("payway=1 and pid='p2' and platID=1", 1, 'p2', 1, $time);
                    }
                    if ($value['pid'] == 'p3') {
                        $this->insertLog("payway=1 and pid='p3' and platID=1", 1, 'p3', 1, $time);
                    }
                    if ($value['pid'] == 'p4') {
                        $this->insertLog("payway=1 and pid='p4' and platID=1", 1, 'p4', 1, $time);
                    }
                    if ($value['pid'] == 'p5') {
                        $this->insertLog("payway=1 and pid='p5' and platID=1", 1, 'p5', 1, $time);
                    }
                    if ($value['pid'] == 'p6') {
                        $this->insertLog("payway=1 and pid='p6' and platID=1", 1, 'p6', 1, $time);
                    }
                }
                if ($value['payway'] == 2) {
                    if ($value['pid'] == 'p1') {
                        $this->insertLog("payway=2 and pid='p1' and platID=1", 2, 'p1', 1, $time);
                    }
                    if ($value['pid'] == 'p2') {
                        $this->insertLog("payway=2 and pid='p2' and platID=1", 2, 'p2', 1, $time);
                    }
                    if ($value['pid'] == 'p3') {
                        $this->insertLog("payway=2 and pid='p3' and platID=1", 2, 'p3', 1, $time);
                    }
                    if ($value['pid'] == 'p4') {
                        $this->insertLog("payway=2 and pid='p4' and platID=1", 2, 'p4', 1, $time);
                    }
                    if ($value['pid'] == 'p5') {
                        $this->insertLog("payway=2 and pid='p5' and platID=1", 2, 'p5', 1, $time);
                    }
                    if ($value['pid'] == 'p6') {
                        $this->insertLog("payway=2 and pid='p6' and platID=1", 2, 'p6', 1, $time);
                    }
                }
            }
            if ($value['platID'] == 2) {
                if ($value['payway'] == 1) {
                    if ($value['pid'] == 'p1') {
                        $this->insertLog("payway=1 and pid='p1' and platID=2", 1, 'p1', 2, $time);
                    }
                    if ($value['pid'] == 'p2') {
                        $this->insertLog("payway=1 and pid='p2' and platID=2", 1, 'p2', 2, $time);
                    }
                    if ($value['pid'] == 'p3') {
                        $this->insertLog("payway=1 and pid='p3' and platID=2", 1, 'p3', 2, $time);
                    }
                    if ($value['pid'] == 'p4') {
                        $this->insertLog("payway=1 and pid='p4' and platID=2", 1, 'p4', 2, $time);
                    }
                    if ($value['pid'] == 'p5') {
                        $this->insertLog("payway=1 and pid='p5' and platID=2", 1, 'p5', 2, $time);
                    }
                    if ($value['pid'] == 'p6') {
                        $this->insertLog("payway=1 and pid='p6' and platID=2", 1, 'p6', 2, $time);
                    }
                }
                if ($value['payway'] == 2) {
                    if ($value['pid'] == 'p1') {
                        $this->insertLog("payway=2 and pid='p1' and platID=2", 2, 'p1', 2, $time);
                    }
                    if ($value['pid'] == 'p2') {
                        $this->insertLog("payway=2 and pid='p2' and platID=2", 2, 'p2', 2, $time);
                    }
                    if ($value['pid'] == 'p3') {
                        $this->insertLog("payway=2 and pid='p3' and platID=2", 2, 'p3', 2, $time);
                    }
                    if ($value['pid'] == 'p4') {
                        $this->insertLog("payway=2 and pid='p4' and platID=2", 2, 'p4', 2, $time);
                    }
                    if ($value['pid'] == 'p5') {
                        $this->insertLog("payway=2 and pid='p5' and platID=2", 2, 'p5', 2, $time);
                    }
                    if ($value['pid'] == 'p6') {
                        $this->insertLog("payway=2 and pid='p6' and platID=2", 2, 'p6', 2, $time);
                    }
                }
            }
            if ($value['platID'] == 3) {
                if ($value['payway'] == 1) {
                    if ($value['pid'] == 'p1') {
                        $this->insertLog("payway=1 and pid='p1' and platID=3", 1, 'p1', 3, $time);
                    }
                    if ($value['pid'] == 'p2') {
                        $this->insertLog("payway=1 and pid='p2' and platID=3", 1, 'p2', 3, $time);
                    }
                    if ($value['pid'] == 'p3') {
                        $this->insertLog("payway=1 and pid='p3' and platID=3", 1, 'p3', 3, $time);
                    }
                    if ($value['pid'] == 'p4') {
                        $this->insertLog("payway=1 and pid='p4' and platID=3", 1, 'p4', 3, $time);
                    }
                    if ($value['pid'] == 'p5') {
                        $this->insertLog("payway=1 and pid='p5' and platID=3", 1, 'p5', 3, $time);
                    }
                    if ($value['pid'] == 'p6') {
                        $this->insertLog("payway=1 and pid='p6' and platID=3", 1, 'p6', 3, $time);
                    }
                }
                if ($value['payway'] == 2) {
                    if ($value['pid'] == 'p1') {
                        $this->insertLog("payway=2 and pid='p1' and platID=3", 2, 'p1', 3, $time);
                    }
                    if ($value['pid'] == 'p2') {
                        $this->insertLog("payway=2 and pid='p2' and platID=3", 2, 'p2', 3, $time);
                    }
                    if ($value['pid'] == 'p3') {
                        $this->insertLog("payway=2 and pid='p3' and platID=3", 2, 'p3', 3, $time);
                    }
                    if ($value['pid'] == 'p4') {
                        $this->insertLog("payway=2 and pid='p4' and platID=3", 2, 'p4', 3, $time);
                    }
                    if ($value['pid'] == 'p5') {
                        $this->insertLog("payway=2 and pid='p5' and platID=3", 2, 'p5', 3, $time);
                    }
                    if ($value['pid'] == 'p6') {
                        $this->insertLog("payway=2 and pid='p6' and platID=3", 2, 'p6', 3, $time);
                    }
                }
            }
        }
        if ($data) {
            $ajaxRet = array(
                'code' => 1,
                'message ' => '更新成功！',
                'result ' => '1',
            );
        } else {
            $ajaxRet = array(
                'code' => 0,
                'message ' => '今天没有充值记录哦',
                'result ' => '0',
            );
        }
        return Json::encode($ajaxRet);
    }

    /*
     * 登录log记录接口
     */

    public function actionLog() {
        $dayTime = strtotime(date("Y-m-d", strtotime("-1 day", time())));
        $dayUpTime = $dayTime + 24 * 3600;
        $where_login = " eventType=3 and eventTime>=$dayTime and eventTime<=$dayUpTime ";
        $login = Log_account::find()->where($where_login)->groupBy('uid')->all();
        // var_dump($login);exit;
        $where_regist = "eventType=3 and eventTime>=$dayTime and eventTime<=$dayUpTime ";
        $regist = Log_account::find()->where($where_regist)->all();
        if ($regist) {
            $DxZlylLogs = 0;
            for ($j = 0; $j < count($regist); $j++) {
                $uid = $regist[$j]['uid'];
                $logModel = Log::find()->where("uid=$uid")->one();
                if (!$logModel) {
                    $sqlstr = '';
                    $sqlstr .= "('" . $uid . "','" . $regist[$j]['eventTime'] . "')";

                    $DxZlylLogs += \Yii::$app->db1->createCommand('INSERT INTO ' . Log::tableName() . ' (`uid`,`reg_time`) VALUES ' . $sqlstr)->execute();
                }
            }
        }
        $data = [];
        if ($login) {
            //刨除当前天注册登录的用户
            foreach ($login as $key => $row) {
                $login_re = Log_account::find()->where("eventType=1 and eventTime>=$dayTime and eventTime<=$dayUpTime " . " and uid=" . $row['uid'])->one();
                if (!$login_re) {
                    $data[] = $row;
                }
            }
            $time = time();
            //每个用户登录的总天数
            $loginModel = 0;
            for ($i = 0; $i < count($data); $i++) {
                $loginModel +=\Yii::$app->db1->createCommand('UPDATE' . Log::tableName() . 'SET `record_time`=' . $time . ',' . '`count_total`=`count_total`+' . 1 . ' WHERE uid =' . $data[$i]['uid'])->execute();
            }

            $data0 = [];
            $data1 = [];
            $data2 = [];
            $data3 = [];
            $data4 = [];
            $week_data = [];
            $weekTwo_data = [];
            $month_data = [];
            foreach ($data as $value) {
                $log_M = Log::find()->where("uid=" . $value['uid'])->one();
                $time = strtotime(date("Y-m-d", strtotime("+1 day", $log_M['reg_time'])));
                $time0 = $time + 24 * 3600;
                // var_dump($log_M['addtime']-3*24*3600);exit;
                if ($value['eventTime'] > $time && $value['eventTime'] < $time0) {
                    $data0[] = $value;
                }
                $time1 = strtotime(date("Y-m-d", strtotime("+3 day", $log_M['reg_time'])));
                $time11 = $time1 + 24 * 3600;
                // var_dump($time1, $time11, $value['eventTime'],$log_M['addtime']);
                //exit;
                if ($value['eventTime'] > $time1 && $value['eventTime'] < $time11) {
                    $data1[] = $value;
                }
                $time2 = strtotime(date("Y-m-d", strtotime("+1 week", $log_M['reg_time'])));
                $time22 = $time2 + 24 * 3600;
                if ($value['eventTime'] > $time2 && $value['eventTime'] < $time22) {
                    $data2[] = $value;
                }

                $time3 = strtotime(date("Y-m-d", strtotime("+1 month", $log_M['reg_time'])));
                $time33 = $time3 + 24 * 3600;
                if ($value['eventTime'] > $time3 && $value['eventTime'] < $time33) {
                    $data3[] = $value;
                }
                if ($value['eventTime'] < $time22) {
                    $week_data[] = $value;
                }
                if ($value['eventTime'] < $time33) {
                    $month_data[] = $value;
                }
            }
            //
//            var_dump($data0, $data1, $data2, $data3, $data4);
//            exit;
            $loginModel0 = 0;
            for ($i = 0; $i < count($data0); $i++) {
                $loginModel0 +=\Yii::$app->db1->createCommand('UPDATE' . Log::tableName() . 'SET `ret2`=' . 1 . ' WHERE uid =' . $data0[$i]['uid'])->execute();
            }
            $loginModel1 = 0;
            for ($i = 0; $i < count($data1); $i++) {
                $loginModel1 +=\Yii::$app->db1->createCommand('UPDATE' . Log::tableName() . 'SET `ret3`=' . 1 . ' WHERE uid =' . $data1[$i]['uid'])->execute();
            }
            $loginModel2 = 0;
            for ($i = 0; $i < count($data2); $i++) {
                $loginModel2 +=\Yii::$app->db1->createCommand('UPDATE' . Log::tableName() . 'SET  `ret7`=' . 1 . ' WHERE uid =' . $data2[$i]['uid'])->execute();
            }
            $loginModel3 = 0;
            for ($i = 0; $i < count($data3); $i++) {
                $loginModel3 +=\Yii::$app->db1->createCommand('UPDATE' . Log::tableName() . 'SET `ret30`=' . 1 . ' WHERE uid =' . $data3[$i]['uid'])->execute();
            }
            //每个用户一周内登录的天数

            $week_model = 0;
            for ($i = 0; $i < count($week_data); $i++) {
                $week_model +=\Yii::$app->db1->createCommand('UPDATE' . Log::tableName() . 'SET  `count7`=`count7`+' . 1 . ' WHERE uid =' . $week_data[$i]['uid'])->execute();
            }
            //每个用户一个月内登录的天数
            $month_model = 0;
            for ($i = 0; $i < count($month_data); $i++) {
                $month_model +=\Yii::$app->db1->createCommand('UPDATE' . Log::tableName() . 'SET   `count30`=`count30`+' . 1 . ' WHERE uid =' . $month_data[$i]['uid'])->execute();
            }
//        var_dump($data);
        }


        if ($login || $regist) {
            $ajaxRet = array(
                'code' => 1,
                'message ' => '更新成功！',
                'result ' => '1',
            );
        } else {
            $ajaxRet = array(
                'code' => 0,
                'message ' => '今天没有登录注册日志哦！',
                'result ' => '0',
            );
        }
        return Json::encode($ajaxRet);
    }

//分享记录
    public function actionShare() {
        $dayTime = strtotime(date("Y-m-d", strtotime("-1 day", time())));
        $dayUpTime = $dayTime + 24 * 3600;
        $where = " eventType=110 and eventTime>=$dayTime and eventTime<=$dayUpTime ";
        $share = Log_normal::find()->where($where)->select('uid,guid,extra,eventTime')->all();
        // $data = [];
        foreach ($share as &$value) {

            $value['extra'] = json_decode($value['extra'], true);
            foreach ($value['extra'] as $key => $row) {
                $value['extra'] = $key;
            }
        }
//        var_dump($share);
//        exit;
        if ($share) {
            $shareLogs = 0;
            for ($j = 0; $j < count($share); $j++) {
                $uid = $share[$j]['uid'];
                $sqlstr = '';
                $sqlstr .= "('" . $uid . "','" . $share[$j]['extra'] . "','" . $share[$j]['eventTime'] . "')";
                $shareLogs += \Yii::$app->db1->createCommand('INSERT INTO ' . Log_share::tableName() . ' (`uid`,`type`,`addtime`) VALUES ' . $sqlstr)->execute();
            }
        }

        if ($share) {
            $ajaxRet = array(
                'code' => 1,
                'message ' => '更新成功！',
                'result ' => '1',
            );
        } else {
            $ajaxRet = array(
                'code' => 0,
                'message ' => '今天没有分享日志哦！',
                'result ' => '0',
            );
        }
        return Json::encode($ajaxRet);
    }

}
