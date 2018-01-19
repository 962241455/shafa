<?php

// qrpay
require_once dirname ( __FILE__ ).DIRECTORY_SEPARATOR.'./AlipayTradePrecreate.php';

// post 数据处理
$sData = file_get_contents('php://input');
if (empty($sData)) {
	$ret = array('code' => 1, 'message' => 'failed', 'result' => "no post data");
	echo json_encode($ret);
	return;
}
else {
	$sdkPay = new AlipayTradePrecreate($appConfig, $sdkReqArgs);
	$sdkPayResult = $sdkPay->sdkPay($sData);
	if (!empty($sdkPayResult)) {
		$ret = array('code' => 0, 'message' => 'success', 'result' => $sdkPayResult);
		echo json_encode($ret);
	}
	else {
		$ret = array('code' => 1, 'message' => 'failed', 'result' => $sdkPayResult);
		echo json_encode($ret);
	}
	return;
}

?>