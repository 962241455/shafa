<?php
ini_set('date.timezone','Asia/Shanghai');
require_once dirname ( __FILE__ ) . DIRECTORY_SEPARATOR . '../PhpExt/log.php';
require_once dirname ( __FILE__ ) . DIRECTORY_SEPARATOR . "lib/WxPay.Api.php";
require_once dirname ( __FILE__ ) . DIRECTORY_SEPARATOR . "lib/WxPay.Notify.php";

class WxPayNotifyCB
{
	private $content; 	// 预下单回调的数据，数组
	private $verify; 	// 验签结果，xml字符串

	public function GetContent()
	{
		return $this->content;
	}

	public function GetVerify()
	{
		return $this->verify;
	}

	public function InitData($data)
	{
		$this->content = $data;
		return true;
	}

	//查询订单
	private function Queryorder($transaction_id)
	{
		$input = new WxPayOrderQuery();
		$input->SetTransaction_id($transaction_id);
		$result = WxPayApi::orderQuery($input);
		if(array_key_exists("return_code", $result)
			&& array_key_exists("result_code", $result)
			&& $result["return_code"] == "SUCCESS"
			&& $result["result_code"] == "SUCCESS")
		{
			return true;
		}
		return false;
	}
	
	// 验签
	protected function myVerifySign()
	{
		$Return_code = "SUCCESS"; // "SUCCESS" 、 "FAIL"
		$Return_msg = "OK";
		// 当返回false的时候，直接回复失败
		$result = WxpayApi::notify(array($this, 'InitData'), $Return_msg);
		if($result == false){
			$Return_code = "FAIL";
		} else {
			//if(!array_key_exists("transaction_id", $this->content) || !array_key_exists("out_trade_no", $this->content) || !array_key_exists("total_fee", $this->content))
			
			if(!array_key_exists("transaction_id", $this->content)) {
				$Return_code = "FAIL";
				$Return_msg = "0 输入参数不正确";
				$result = false;
			} else {
				//查询订单，判断订单真实性
				if(!$this->Queryorder($this->content["transaction_id"]))
				{
					$Return_code = "FAIL";
					$Return_msg = "1 订单查询失败";
					$result = false;
				}
				else
				{
					$Return_code = "SUCCESS";
					$result = true;
				}
			}
		}

		$obj = new WxPayResults();
		$obj->SetData("return_code", $Return_code);
		$obj->SetData("return_msg", $Return_msg);
		$this->verify = $obj->ToXml();

		return $result;
	}

	public static function VerifySign()
	{
		$ret = array('code' => 1, 'message' => 'failed', 'result' => null);
		//$ret = array('code' => 0, 'message' => 'success', 'result' => $result);
		try {
			$cbNotify = new self();
			$bOK = $cbNotify->myVerifySign();
			if($bOK == false){
				$ret["code"] = 1;
				$ret["message"] = "failed";
			} else {
				$ret["code"] = 0;
				$ret["message"] = "success";
			}
			$ret["result"] = $cbNotify->GetContent();
			$ret["verify"] = $cbNotify->GetVerify();
		} catch (Exception $e) {
			$obj = new WxPayResults();
			$obj->SetData("return_code", "FAIL");
			$obj->SetData("return_msg", $e->getMessage());
			$verify = $obj->ToXml();

			$ret["code"] = 1;
			$ret["message"] = "failed";
			$ret["verify"] = $verify;
		}
		if ($ret["code"] != 0) {
			Log::INFO(json_encode($ret));
		}

		echo json_encode($ret);
	}
}

// App pay 需要的订单信息
class WxPayAppOrder extends WxPayDataBase
{
	// 设置参数
	public function SetData($key, $value)
	{
		$this->values[$key] = $value;
	}

	// 转换为json
	public function ToJson()
	{
		if(!is_array($this->values) || count($this->values) <= 0)
		{
    		throw new WxPayException("数组数据异常！");
    	}
    	return json_encode($this->values);
	}

	//获取 Unix 时间戳
	public function getTimeStamp()
	{
		$t = time();
		return "" . $t;
	}

	/**
	 * 获取毫秒级别的时间戳
	 */
	public function getMillisecond()
	{
		//获取毫秒的时间戳
		$time = explode ( " ", microtime () );
		$time = $time[1] . ($time[0] * 1000);
		$time2 = explode( ".", $time );
		$time = $time2[0];
		return $time;
	}
}
/**
* 微信支付 wxpay
*/
class WxPayService
{
	public function __construct()
	{
	}
	public function __destruct()
	{
	}

	// 微信支付支付。 trade_type： "APP" 、 "NATIVE"
	protected function myPay($req, $trade_type)
	{
		if (empty($req)) {
			throw new WxPayException("no post data");
		}
		$tReq = json_decode($req);
		if (count($tReq) == 0) {
			throw new WxPayException("error post data: " . $req);
		}
		if ($trade_type != "NATIVE" && $trade_type != "APP") {
			throw new WxPayException("error trade_type: " . $trade_type);
		}

		$out_trade_no = $tReq->out_trade_no; 	// * 商家生成的订单号
		$total_amount = $tReq->total_amount*100; 	// * 订单总金额，单位为分
		$name = $tReq->name; 					// * 订单标题
		$desc = $tReq->desc; 					// * 订单描述
		$pid = $tReq->pid; 						// * 产品ID
		$notify_url = $tReq->notify_url; 		// * 支付回调地址


		$input = new WxPayUnifiedOrder();
		$input->SetBody($name); // * 商品描述，应用市场上的APP名字-商品概述，如：腾讯充值中心-QQ会员充值
		$input->SetAttach($pid); // 附加数据，在查询API和支付通知中原样返回，可作为自定义参数使用。
		$input->SetOut_trade_no($out_trade_no);
		$input->SetTotal_fee($total_amount);
		$input->SetTime_start(date("YmdHis"));
		$input->SetTime_expire(date("YmdHis", time() + WxPayConfig::Expire_Time));
		$input->SetTrade_type($trade_type);
		$input->SetProduct_id($pid);
		$input->SetNotify_url($notify_url);//异步通知url
		//$input->SetGoods_tag("test");

		$result = WxPayApi::unifiedOrder($input);
		// $qr_code = $result["code_url"];
		// $order_info = $result["prepay_id"];

		return $result;
	}

	// 二维码支付
	public static function qrPay()
	{
		$ret = null;
		try {
			//获取post的数据
			//$sData = $GLOBALS['HTTP_RAW_POST_DATA'];
			$sData = file_get_contents('php://input');
			$wxpays = new self();
			$result = $wxpays->myPay($sData, "NATIVE");
			$return_code = $result["return_code"];
			$result_code = $result["result_code"];
			if ($return_code == "SUCCESS" && $result_code == "SUCCESS" && 
				array_key_exists("code_url", $result) && !empty($result["code_url"]))
			{
				$ret = array('code' => 0, 'message' => 'success', 'result' => $result);
			} else {
				$ret = array('code' => 1, 'message' => 'failed', 'result' => $result);
			}
		} catch (Exception $e) {
			$result = $e->getMessage();
			$ret = array('code' => 1, 'message' => 'failed', 'result' => $result);
		}
		if ($ret["code"] != 0) {
			Log::INFO(json_encode($ret));
		}

		echo json_encode($ret);
	}

	// App 支付
	public static function sdkPay()
	{
		$ret = null;
		try {
			//获取post的数据
			//$sData = $GLOBALS['HTTP_RAW_POST_DATA'];
			$sData = file_get_contents('php://input');
			$wxpays = new self();
			$result = $wxpays->myPay($sData, "APP");
			$return_code = $result["return_code"];
			$result_code = $result["result_code"];
			if ($return_code == "SUCCESS" && $result_code == "SUCCESS" && array_key_exists("prepay_id", $result) && !empty($result["prepay_id"])) {
				//统一下单接口返回正常的prepay_id，再按签名规范重新生成签名后，将数据传输给APP。
				//参与签名的字段名为 appid，partnerid，prepayid，noncestr，timestamp，package。注意：package的值格式为Sign=WXPay 
				//
				$req = new WxPayAppOrder();
				$req->SetData("appid", WxPayConfig::APPID);
				$req->SetData("partnerid", WxPayConfig::MCHID);
				$req->SetData("prepayid", $result["prepay_id"]);
				$req->SetData("noncestr", WxPayApi::getNonceStr());
				$req->SetData("timestamp", $req->getTimeStamp());
				$req->SetData("package", "Sign=WXPay");
				$req->SetSign();
				//$req->SetData("extData", "app data");
				$ret = array('code' => 0, 'message' => 'success', 'result' => $req->ToJson());
			} else {
				$ret = array('code' => 1, 'message' => 'failed', 'result' => json_encode($result));
			}
		} catch (Exception $e) {
			$ret = array('code' => 1, 'message' => 'failed', 'result' => $e->getMessage());
		}
		if ($ret["code"] != 0) {
			Log::INFO(json_encode($ret));
		}

		echo json_encode($ret);
	}

	// 异步回调通知
	public static function qrNotify()
	{
		WxPayNotifyCB::VerifySign();
	}
}

?>
