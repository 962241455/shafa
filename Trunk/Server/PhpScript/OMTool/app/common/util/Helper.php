<?php

namespace common\util;

use InvalidArgumentException;
use Yii;
use yii\helpers\Json;
use common\models\Ucenter;
use common\util\qrcode\QRCode;

class Helper {

    /**
     * 验证手机号码
     */
    public static function checkPhoneNum($phone_number) {
        return preg_match("/^1[3|4|5|7|8][0-9]{9}$/", $phone_number);
    }

    /**
     * 验证电信手机号码
     */
    public static function checkTelecomPhoneNum($phone_number) {
        return preg_match("/^(189|177|133|181|180|153){1}[0-9]{8}$/", $phone_number);
    }

    /**
     * 密码加密处理
     * @param string $password
     * @return string
     */
    public static function passwordMd5($password) {
        return md5($password);
    }

    /**
     * 返回指定范围内的随机串
     * @param int $length 随机串长度
     * @param string $map 随机串种子字符集合
     * @return string
     * @throws InvalidArgumentException
     */
    public static function randomString($length, $map = 'abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ') {
        if (!is_string($map) || ($mapLength = mb_strlen($map, 'utf8')) < 2)
            throw new InvalidArgumentException('$map must be a string and its length must be greater than 1');
        $length = intval($length);
        if ($length < 1)
            throw new InvalidArgumentException('$length must be a integer greater than 0');
        $str = '';
        while ($length-- > 0) {
            $str .= mb_substr($map, mt_rand(0, $mapLength - 1), 1);
        }
        return $str;
    }

    /**
     * 验证邮箱
     */
    public static function checkEmail($email) {
        return preg_match('/\w{6,16}@\w{1,}\.\w{2,3}/i', $email);
    }

    /**
     * 判断是否URL地址
     * @param type $url
     * @return boolean
     */
    public static function isUrl($url) {
        if (!preg_match('/http:\/\/[\w.]+[\w\/]*[\w.]*\??[\w=&\+\%]*/is', $url)) {
            return FALSE;
        }
        return TRUE;
    }

    /**
     * 判断是否在微信浏览器
     */
    public static function isWeiXin() {
        if (strpos($_SERVER['HTTP_USER_AGENT'], 'MicroMessenger') !== false) {
            return true;
        } return false;
    }

    /**
     * 金额格式化，显示两位小数  如：0.00
     * @param number $money
     * @return number
     */
    public static function moneyFormat($money) {
        return sprintf("%.2f", $money);
    }

    /**
     * 去除html
     */
    public static function reHtml($str) {
        return preg_replace("/<(.*?)>/", "", $str);
    }

    /**
     * api执行成功返回json（已弃用）
     */
    public static function apiSuc($msg = '', $url = '') {
        $result = [
            'status' => 1,
            'errcode' => 0,
            'msg' => $msg
        ];
        if ($url)
            $result['url'] = $url;
        return JSON::encode($result);
    }

    /**
     * api执行失败返回json（已弃用）
     */
    public static function apiErr($errcode = '-1', $msg = '', $url = '') {
        $result = [
            'status' => 0,
            'errcode' => $errcode,
            'msg' => $msg
        ];
        if ($url)
            $result['url'] = $url;
        return JSON::encode($result);
    }

    /**
     * api返回数据
     * @param int $errcode
     * @param string $msg
     * @param array|false $data
     */
    public static function apiRet($errcode = 0, $data = false, $msg = '') {
        $result['status'] = ($errcode == 0) ? 1 : 0;
        $result['errcode'] = $errcode;
        $result['msg'] = $msg;
        if ($data) {
            $result['data'] = $data;
        }
        return Json::encode($result);
    }

    /**
     * 生成随机用户名
     */
    public static function createRandUsername() {
        do {
            $username = 'M_' . substr(REQUEST_TIME, 5, 5) . rand(100, 999);
        } while (Ucenter::find()->where(['username' => $username])->count());
        return $username;
    }

    //写日志
    public static function writeLog($logFile, $str) {
        $logFile = fopen(APP_DIR . '/runtime/logs/' . $logFile, 'a');
        fwrite($logFile, date('Y-m-d H:i:s') . ': ' . $str . "\n");
    }

    /**
     * GET 请求
     * @param string $url
     */
    public static function http_get($url) {
        $appkey = "fd057336f31a7fbc5353e566f2af578b";
        $seckey = "1167b990d7a42834";
        $time = time();
        $rand = rand(100000, 999999);
        $sign = md5($seckey . $time . $rand);
        // header('time', $time);
        $headers = array(
            'appKey:' . $appkey,
            'sign:' . $sign,
            'time:' . $time,
            'rand:' . $rand,
        );

        $oCurl = curl_init();
        if (stripos($url, "https://") !== FALSE) {
            curl_setopt($oCurl, CURLOPT_SSL_VERIFYPEER, FALSE);
            curl_setopt($oCurl, CURLOPT_SSL_VERIFYHOST, FALSE);
        }
        curl_setopt($oCurl, CURLOPT_URL, $url);
        curl_setopt($oCurl, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($oCurl, CURLOPT_HTTPHEADER, $headers);

        $sContent = curl_exec($oCurl);
        $aStatus = curl_getinfo($oCurl);
        curl_close($oCurl);
        if (intval($aStatus["http_code"]) == 200) {
            return $sContent;
        } else {
            return false;
        }
    }

    /**
     * POST 请求
     * @param string $url
     * @param array $param
     * @return string content
     */
    public static function http_post($url, $param, $type = '') {
        $key = 2;
        $time = time();
        $rand = rand(100000, 999999);
        $sign = $time . $rand;
        // header('time', $time);
        $headers = array(
            'appkey:' . $key,
            'sign:' . $sign,
            'time:' . $time,
            'rand:' . $rand,
        );
        //  $header = array('appkey:1111', 'sign:5555555');
        $oCurl = curl_init();
        if (stripos($url, "https://") !== FALSE) {
            curl_setopt($oCurl, CURLOPT_SSL_VERIFYPEER, FALSE);
            curl_setopt($oCurl, CURLOPT_SSL_VERIFYHOST, false);
        }
        if (is_string($param)) {
            $strPOST = $param;
        } else {
            $aPOST = array();
            foreach ($param as $key => $val) {
                $aPOST[] = $key . "=" . urlencode($val);
            }
            $strPOST = join("&", $aPOST);
        }
        curl_setopt($oCurl, CURLOPT_URL, $url);
        curl_setopt($oCurl, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($oCurl, CURLOPT_HTTPHEADER, $headers);
        curl_setopt($oCurl, CURLOPT_POST, true);
        curl_setopt($oCurl, CURLOPT_POSTFIELDS, $strPOST);
        if ($type == 'json') {
            curl_setopt($oCurl, CURLOPT_HTTPHEADER, array(
                'Content-Type: application/json',
                'Content-Length: ' . strlen($strPOST))
            );
        }
        $sContent = curl_exec($oCurl);
        $aStatus = curl_getinfo($oCurl);
        curl_close($oCurl);
        if (intval($aStatus["http_code"]) == 200) {
            return $sContent;
        } else {
            self::writeLog('http_post_' . date("Ymd", REQUEST_TIME), 'content:' . json_encode($aStatus));
            return false;
        }
    }

    /**
     * 使用fsockopen传送post
     * @param string $URL
     * @param string $data
     * @param string $cookie
     * @param string $referrer
     * @return string
     */
    public static function fsock_post($URL, $data, $cookie, $referrer = "") {//有些服务器可能需要通过此方式
        $URL_Info = parse_url($URL);
        // making string from $data
        // Find out which port is needed - if not given use standard (=80)
        if (!isset($URL_Info["port"])) {
            $URL_Info["port"] = 80;
        }
        // building POST-request:
        $request.="POST " . $URL_Info["path"] . " HTTP/1.1\n";
        $request.="Host: " . $URL_Info["host"] . "\n";
        $request.="Referer: $referer\n";
        $request.="Content-type: application/x-www-form-urlencoded\n";
        $request.="Content-length: " . strlen($data) . "\n";
        $request.="Connection: close\n";
        $request.="Cookie:   $cookie\n";
        $request.="\n";
        $request.=$data . "\n";
        $fp = fsockopen($URL_Info["host"], $URL_Info["port"]);
        fputs($fp, $request);
        while (!feof($fp)) {
            $result .= fgets($fp, 1024);
        }
        fclose($fp);
        $result = preg_replace(array("'HTTP/1[\w\W]*<xml>'i", "'</xml>[\w\W]*0'i"), array("<xml>", "</xml>"), $result);
        return trim($result);
    }

    /**
     * curl方式提交数据
     */
    public static function vcurl($url, $post = '', $cookie = '', $cookiejar = '', $referer = '') {
        $appkey = "fd057336f31a7fbc5353e566f2af578b";
        $seckey = "1167b990d7a42834";
        $time = time();
        $rand = rand(100000, 999999);
        $sign = md5($seckey . $time . $rand);
        // header('time', $time);
        $headers = array(
            'appKey:' . $appkey,
            'sign:' . $sign,
            'time:' . $time,
            'rand:' . $rand,
        );
        $tmpInfo = '';
        $cookiepath = getcwd() . './' . $cookiejar;
        //$cookiepath ='./web/data/'.$cookiejar;
        $curl = curl_init();
        curl_setopt($curl, CURLOPT_URL, $url);
        curl_setopt($curl, CURLOPT_USERAGENT, $_SERVER['HTTP_USER_AGENT']);
        if ($referer) {
            curl_setopt($curl, CURLOPT_REFERER, $referer);
        } else {
            curl_setopt($curl, CURLOPT_AUTOREFERER, 1);
        }
        if ($post) {
            curl_setopt($curl, CURLOPT_POST, 1);
            curl_setopt($curl, CURLOPT_POSTFIELDS, $post);
        }
        if ($cookie) {
            curl_setopt($curl, CURLOPT_COOKIE, $cookie);
        }
        if ($cookiejar) {
            curl_setopt($curl, CURLOPT_COOKIEJAR, $cookiepath);
            curl_setopt($curl, CURLOPT_COOKIEFILE, $cookiepath);
        }
        //curl_setopt($curl, CURLOPT_FOLLOWLOCATION, 1);
        curl_setopt($curl, CURLOPT_TIMEOUT, 15);
        curl_setopt($curl, CURLOPT_HEADER, 0);
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($curl, CURLOPT_HTTPHEADER, $headers);
        curl_setopt($curl, CURLOPT_POST, true);
        $tmpInfo = curl_exec($curl);
        if (curl_errno($curl)) {
            return curl_error($curl);
        }
        curl_close($curl);
        return $tmpInfo;
    }

    /**
     * http访问传送post请求
     */
    public static function HTTP_Post2($url, $post = '', $cookie = '', $cookiejar = '', $referer = '') {
        if (function_exists('curl_init')) {
            return Helper::vcurl($url, $post, $cookie, $cookiejar, $referer);
        } else if (function_exists('file_get_contents')) {
            $context = array();
            $context['http'] = array('method' => 'POST', 'content' => $post, $cookie);
            return file_get_contents($url);
        } else if (function_exists('fsockopen')) {
            return Helper::fsock_post($url, $post, $cookie, $referer);
        }
    }

    /*
     * 创建字符串二维码图片
     *
     * @param string $data    字符串数据
     * @param string $outfile 输出文件，如果没设置则输出到浏览器
     */

    public static function createQR($data, $outfile = null) {
        try {
            $code = new QRCode($data);
            if ($outfile) {
                $outfile = WWW_PATH . '/uploads/img/qrcodes/' . $outfile;
            }
            $code->create($outfile);
            return true;
        } catch (\Exception $e) {
            return false;
        }
    }

    /**
     * 取带毫秒时间
     * return ['mise','time']
     */
    public static function msectime() {
        $t = explode(' ', microtime());
        $t[0] = sprintf("%03d", round(floatval($t[0]) * 1000));
        return $t;
    }

    /**
     * 取13位毫秒级时间戳
     * @return string
     */
    public static function getMillisecond() {
        list($t1, $t2) = explode(' ', microtime());
        return $t2 . sprintf("%03d", round(floatval($t1) * 1000));
    }

    /**
     * 导出csv
     * @param $file_name 文件名 必填
     * @param $headerDate 表头数据
     * @param $bodyData 数据
     * @param $writer 1保存文件到服务器 0直接输出到浏览器
     */
    public static function toCsv($file_name, $headerDate = [], &$bodyData, $writer = 0) {
        if ($writer) {
            $fp = fopen("../uploads/img/excel/" . $file_name . '.csv', 'w');
        } else {
            // 输出Excel文件头，可把user.csv换成你要的文件名
            if (!headers_sent()) {
                header('Content-Type: application/vnd.ms-excel');
                header('Content-Disposition: attachment;filename="' . $file_name . '.csv"');
                header('Cache-Control: max-age=0');
            }
            // 打开PHP文件句柄，php://output 表示直接输出到浏览器
            $fp = fopen('php://output', 'a');
        }

        if ($headerDate) {
            foreach ($headerDate as $i => $v) {
                // CSV的Excel支持GBK编码，一定要转换，否则乱码
                $headerDate[$i] = iconv('utf-8', 'gbk', $v);
            }
            // 将数据通过fputcsv写到文件句柄
            fputcsv($fp, $headerDate);
        }

        // 逐行取出数据，不浪费内存
        foreach ($bodyData as $row) {
            foreach ($row as $i => $v) {
                /**
                 * 此处比用 iconv是为了处理微信昵称里面的符号  用iconv这里不能转换
                 * 用mb_convert_encoding会默认吧符号转成？(问号)
                 */
                $row[$i] = @mb_convert_encoding($v, 'gbk', 'utf-8');
//                $row[$i] = iconv('utf-8', 'gbk', $v);
                $row[$i] = "\t" . $row[$i];
            }
            fputcsv($fp, $row);
        }
        fclose($fp);
        if ($writer) {
            return IMG_URL . '/excel/' . $file_name . '.csv';
        }
        return true;
    }

}
