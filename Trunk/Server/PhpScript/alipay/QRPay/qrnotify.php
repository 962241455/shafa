<?php

// qrnotify
require_once dirname ( __FILE__ ).DIRECTORY_SEPARATOR.'./AlipayTradePrecreate.php';

//$postData = file_get_contents('php://input');
$args = $_GET;
if (empty($args)) {
	/*
	if (!empty($postData)) {
		$args = urldecode($postData);
	}
	//*/
	//*
	if (!empty($_POST)) {
		$args = $_POST;
	}
	//*/
}

// 数据处理
$ret = array('code' => 1, 'message' => 'failed', 'result' => "nothing");
if (empty($args)) {
	$ret = array('code' => 1, 'message' => 'failed', 'result' => "no data");
}
elseif (empty($args['sign']) || empty($args['sign_type'])) {
	$ret = array('code' => 1, 'message' => 'failed', 'result' => "no sign");
}
else {
	$alipay = new AlipayTradePrecreate($appConfig, $preReqArgs);
	$result = $alipay->CBVerifySign($args);
	if (!empty($result) && $result) {
		$ret = array('code' => 0, 'message' => 'success', 'result' => $result);
	}
	else {
		$ret = array('code' => 1, 'message' => 'failed', 'result' => $result);
	}
}
echo json_encode($ret);
return;

?>