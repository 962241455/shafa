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
	$qrPay = new AlipayTradePrecreate($appConfig, $preReqArgs);
	$qrPayResult = $qrPay->qrPay($sData);
	if (!empty($qrPayResult) && ("10000"==$qrPayResult->code) && !empty($qrPayResult->qr_code)) {
		$ret = array('code' => 0, 'message' => 'success', 'result' => $qrPayResult);
		echo json_encode($ret);
	}
	else {
		$ret = array('code' => 1, 'message' => 'failed', 'result' => $qrPayResult);
		echo json_encode($ret);
	}
	return;
}

?>