<?php

require_once dirname ( __FILE__ ).DIRECTORY_SEPARATOR.'./../AopSdk.php';
require_once dirname ( __FILE__ ).DIRECTORY_SEPARATOR.'./config.php';

// 预下单 二维码支付
class AlipayTradePrecreate {

	// 支付宝 app 相关配置
	public $app_id = "2016082000294897";
	public $gateway_url = "https://openapi.alipaydev.com/gateway.do";
	public $private_key = "MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCeSuPmWapt4tU7OEbGdd5lQ+kB/DotvYrd/s2lwmpPzX+GGlcfnjgwkWDAb1PQrJ8T1vzdBy2LjtK3RAVqf96sR/2MimJZuVNmtE6KQgBmi1hov0588e4PQU6O9egjAyR+TXa2ArUy+MB68GInpefvs6YXnhLlvvGvNvD+yHN6JV1GWHW2uJSI9PD7/vYJ6LCIBzzn7giSDEG12KYCJJsz+8XedYN7BBcoBcDkGW1MwAst0c79bSjNzyjh/R8a4tshe3ejnH6b06YJ0NiqkjUixlhslwZ3hRT7B0oghacGCWYj4AHxEcpVNb0tKf88gklqvgUC8agdVS/kJnfNniFRAgMBAAECggEASby3Nznzw2aUUBbiGVcU93VQGMWnUGFoTAuDPsE3Bt/ClPS2OxtYL3+5Y0s47w9Kt1JBzrCmTcmFbSu5nifc0cJjYVGhiQxkxoYdxBgE2b/1ui3L4TZN4Dta3gu9THoNSOzK7PSL9iecemh6QN/vEGFOcNgJE48ERMvCLd2wtWfw4yacF1KKNF3gOtxw7z/h5wsfrjbmGTOxDBxkthi5TXDRNvL/o+yx5n0Wr5Ri96OdHCwEI89pTsF6b/lZe1C0KU/myYvtZaUNMvcHI7bEz1+p4LKQpHznqZEni9+AcZ1T+OFW6wy0/2y8nDIou5rWmG9s6rNAGQy+gmQrHhcvQQKBgQDKlAMdRngH3Te3veHW9Wgsh8bN4BMEpLF8OFFGuGO/EzBg6UGfnX/UUQg1G/xTvyb/tOgFUZWVJ5/6NqYVTYvH1nH1JspVhIcftria2wbQ5blJzszngo2Sv6M9XXiIXKR7Dux+WlPOQzuMaENiYNgQKoTJ+9xWd1c7LI6ZSkM3eQKBgQDICStMdvA+7hFKk93HfxdcTgbWE668yLQVPwc39MV38g2Ktg7uLhkjYECT9/xXcjByUmf2GVOYy+Mdt+2po+5e0ibVNwGDg97G6MpKDBrpsSkfA+u8RJLqVWmXeWBIwXqsdRiuG7jYDbP0GdBkTvXZus1bYLStl7I0jfqWSXFKmQKBgEoPwvO5B7kYT36FlUOZhPSCz1QFT+6qp5janhxU3WLGCTHlFXDdjBZ7aZzBFocno4JpCUqogR9+1SYNRLsVFr2A0TjnbaHGSgB2NReoa92DnzI0wQUC3e+A0JVmzuJLvHahBiVLsMgAHI1AsSIOde+zG8kco3mZN/MSXy/7zodBAoGAfF4HB5FjKR0GryFj3+bKdV8lrO+r0j/Ohu8a49VQ+JQLi1RJ0BflFTOAsv6ZaxzZtho5/K4eZX9OA2oZX0FGsLlj32hFjqjsVyrgqk0AZo75DAl6BSF1XjAgaEbUcCeqx5I99/HQaLOMUJXEFLlq7SXRC6ECdHM+HqKvS8T5pPECgYEAry/u6xL3HxAePKiNx3TgWcC3/NsWUJnC9TSrAnj534vzUDlH/8Vwb3iBnbCactnbK8R7mv4aaCAN2JI+2yVI8G4Z5PEKU79N97L7cSJrXjZpHZ/T6ZhF+qm49vpvBNSGluzXTt3h31YzE7BVsF6rrluqyYQJcNaS6Kxqkr55VfA=";
	public $alipay_public_key = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA99NDyl/02xaDJwjVBdSaWgo9TCgmrcTuS86g8M0HG+UMfzll37EgJKizT4UCmlRv6EBTSiScLoDKDGUOOR56j5dTRKAzRJ9aYphLcJr1vyInWSvQd/BjlY9wiGj+1Kso9Ut8AE1IhDZpzE25Snz3efXeEoUr6ALzbPz8HLgwZ/IWd6eFzlbWqRu8nJX0Mt8OlG6L1ct1s+3AcPIjJIpTLsHmU/jLjjTEBo+jQqXKO1unoQM+GFY+N52/7Xi+sl8xrWSH+mUWnNsGsS9FXfeAxS+NqxW4VP9CwkWLMM2s7o/mlvxYiFGG3zPP1nGnzErot5CN+ZCIDjOfjqkxTghPxwIDAQAB";
	//public $notify_url = null;
	public $timeout_express = "10m"; 	// m, h, d, c
	public $MaxQueryRetry = "10"; 		//最大查询重试次数
	public $QueryDuration = "3"; 		//查询间隔

	// 公共请求参数。预下单(二维码支付) 与 sdk 支付 基本相同
	//public $app_id = $appConfig['appID'];
	public $method = "";
	public $format = "JSON";
	public $charset = "utf-8";
	public $sign_type = "RSA2";
	public $version = "1.0";
	//public $notify_url = $appConfig['notifyUrl'];
	public $app_auth_token = null;
	public $biz_content = null;
	public $sign = null;
	public $timestamp = null;

	// 构造函数
	function __construct($appConfig, $comReqArgs) {
		// appConfig
		$this->app_id = $appConfig['appID'];
		$this->gateway_url = $appConfig['gatewayUrl'];
		$this->private_key = $appConfig['appSecKey'];
		$this->alipay_public_key = $appConfig['aliPubKey'];
		//$this->notify_url = $appConfig['notifyUrl'];
		$this->timeout_express = $appConfig['timeout_express'];
		$this->MaxQueryRetry = $appConfig['MaxQueryRetry'];
		$this->QueryDuration = $appConfig['QueryDuration'];

		// 公共请求参数 comReqArgs
		$this->method = $comReqArgs['method'];
		$this->format = $comReqArgs['format'];
		$this->charset = $comReqArgs['charset'];
		$this->sign_type = $comReqArgs['sign_type'];
		$this->version = $comReqArgs['version'];
		if (array_key_exists('app_auth_token', $comReqArgs)) {
			$this->app_auth_token = $comReqArgs['app_auth_token'];
		}
		// 公共请求参数 由req确定的数据
		$this->biz_content = null;
		$this->sign = null;
		$this->timestamp = null;
		// 检查参数
		if(empty($this->app_id)||trim($this->app_id)==""){
			throw new Exception("appid should not be NULL!");
		}
		if(empty($this->gateway_url)||trim($this->gateway_url)==""){
			throw new Exception("gateway_url should not be NULL!");
		}
		if(empty($this->private_key)||trim($this->private_key)==""){
			throw new Exception("private_key should not be NULL!");
		}
		if(empty($this->alipay_public_key)||trim($this->alipay_public_key)==""){
			throw new Exception("alipay_public_key should not be NULL!");
		}
		if(empty($this->charset)||trim($this->charset)==""){
			throw new Exception("charset should not be NULL!");
		}
		if(empty($this->sign_type)||trim($this->sign_type)==""){
			throw new Exception("sign_type should not be NULL");
		}
		if(empty($this->QueryDuration)||trim($this->QueryDuration)==""){
			throw new Exception("QueryDuration should not be NULL!");
		}
		if(empty($this->MaxQueryRetry)||trim($this->MaxQueryRetry)==""){
			throw new Exception("MaxQueryRetry should not be NULL!");
		}
	}

	// 当面付2.0预下单二维码支付）、SDK支付 的 异步回调验签
	public function CBVerifySign($params)
	{
		if (empty($params) || empty($params['sign']) || empty($params['sign_type'])) {
			return false;
		}
		//$sign = $params['sign'];
		//$sign_type = $params['sign_type'];
		$sign_type = "RSA2";
		$aop = new AopClient ();
		$aop->alipayrsaPublicKey = $this->alipay_public_key;

		return $aop->rsaCheckV1($params, null, $sign_type);
	}

	//当面付2.0预下单(生成二维码)
	public function qrPay($req) {
		//$tReq = json_decode($req, true);
		//$this->writeLog($this->biz_content);
		$tReq = json_decode($req);
		$content = array();
		$content['timeout_express'] = $this->timeout_express; 	// * 过期时间
		$content['out_trade_no'] = $tReq->out_trade_no; 		// * 商家生成的订单号
		$content['total_amount'] = $tReq->total_amount; 		// * 总金额
		$content['subject'] = $tReq->subject; 					// * 订单标题
		$content['body'] = $tReq->body; 						// * 订单描述
		$pid = $tReq->pid; 						// * 产品ID
		$notify_url = $tReq->notify_url; 		// * 支付回调地址
		
		if (!empty($tReq->seller_id))
			$content['seller_id'] = $tReq->seller_id;
		if (!empty($tReq->discountable_amount))
			$content['discountable_amount'] = $tReq->discountable_amount;
		if (!empty($tReq->goods_detail))
			$content['goods_detail'] = $tReq->goods_detail;
		if (!empty($tReq->operator_id))
			$content['operator_id'] = $tReq->operator_id;
		if (!empty($tReq->store_id))
			$content['store_id'] = $tReq->store_id;
		if (!empty($tReq->terminal_id))
			$content['terminal_id'] = $tReq->terminal_id;
		if (!empty($tReq->extend_params))
			$content['extend_params'] = $tReq->extend_params;

		// 生成业务参数
		$this->biz_content = json_encode($content);
		$request = new AlipayTradePrecreateRequest();
		$request->setBizContent ( $this->biz_content );
		$request->setNotifyUrl ( $notify_url );

		// 首先调用支付api
		$aop = new AopClient ();
		$aop->appId = $this->app_id;
		$aop->gatewayUrl = $this->gateway_url;
		$aop->rsaPrivateKey = $this->private_key;
		$aop->alipayrsaPublicKey = $this->alipay_public_key;
		$aop->signType = $this->sign_type;
		$aop->apiVersion = $this->version;
		$aop->postCharset = $this->charset;
		$aop->format=$this->format;
		// 开启页面信息输出
		$aop->debugInfo=true;
		$token = null;
		$appAuthToken = $this->app_auth_token;
		$response = $aop->execute($request, $token, $appAuthToken);
		$result = $response->alipay_trade_precreate_response;
		
		return $result;
	}

	// SDK支付
	public function sdkPay($req)
	{
		//$tReq = json_decode($req, true);
		//$this->writeLog($this->biz_content);
		$tReq = json_decode($req);
		$content = array();
		$content['timeout_express'] = $this->timeout_express; 	// * 过期时间
		$content['out_trade_no'] = $tReq->out_trade_no; 		// * 商家生成的订单号
		$content['total_amount'] = $tReq->total_amount; 		// * 总金额
		$content['subject'] = $tReq->subject; 					// * 订单标题
		$content['body'] = $tReq->body; 						// * 订单描述
		$content['product_code'] = 'QUICK_MSECURITY_PAY'; 		// * 销售产品码，商家和支付宝签约的产品码，为固定值QUICK_MSECURITY_PAY
		//$content['goods_type'] = 0; 							// * 虚拟类商品
		$pid = $tReq->pid; 						// * 产品ID
		$notify_url = $tReq->notify_url; 		// * 支付回调地址

		if (!empty($tReq->goods_type))
			$content['goods_type'] = $tReq->goods_type;
		if (!empty($tReq->passback_params))
			$content['passback_params'] = $tReq->passback_params;
		if (!empty($tReq->promo_params))
			$content['promo_params'] = $tReq->promo_params;
		if (!empty($tReq->extend_params))
			$content['extend_params'] = $tReq->extend_params;
		if (!empty($tReq->store_id))
			$content['store_id'] = $tReq->store_id;
		if (!empty($tReq->enable_pay_channels))
			$content['enable_pay_channels'] = $tReq->enable_pay_channels;
		if (!empty($tReq->disable_pay_channels))
			$content['disable_pay_channels'] = $tReq->disable_pay_channels;

		// 生成业务参数
		$this->biz_content = json_encode($content);
		$request = new AlipayTradeAppPayRequest();
		$request->setBizContent ( $this->biz_content );
		$request->setNotifyUrl ( $notify_url );
		//$request->setProdCode  ( 'QUICK_MSECURITY_PAY' );

		// 首先调用支付api
		$aop = new AopClient ();
		$aop->appId = $this->app_id;
		$aop->gatewayUrl = $this->gateway_url;
		$aop->rsaPrivateKey = $this->private_key;
		$aop->alipayrsaPublicKey = $this->alipay_public_key;
		$aop->signType = $this->sign_type;
		$aop->apiVersion = $this->version;
		$aop->postCharset = $this->charset;
		$aop->format=$this->format;
		// 开启页面信息输出
		$aop->debugInfo=true;
		//$token = null;
		//$appAuthToken = $this->app_auth_token;
		$result = $aop->sdkExecute($request);

		return $result;
		//return htmlspecialchars($result);
	}
}

?>