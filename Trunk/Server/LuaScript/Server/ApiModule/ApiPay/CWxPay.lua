-- CWxPay

-- 微信 支付。构造函数
function CWxPay:Ctor()
	--
end

function CWxPay:WxPayQR(notify_url, pid, out_trade_no, total_amount, name, desc)
	local url = "/PhpScript/wxpay/qrpay.php"
	local args = {}
	args.notify_url = notify_url
	args.pid = pid
	args.out_trade_no = out_trade_no
	args.total_amount = total_amount
	args.name = name
	args.desc = desc
--print(TextCode.JsonEncode(args))

    local oRet = ReqEx.SubReq(url, {}, TextCode.JsonEncode(args), ngx.HTTP_POST)
    if oRet.status == ngx.HTTP_OK then
		return TextCode.JsonDecode(oRet.body)
	else
		return {code = RetCode.Failed[1], message = RetCode.Failed[2], result = oRet}
    end
end

function CWxPay:WxPaySDK(notify_url, pid, out_trade_no, total_amount, name, desc)
	local url = "/PhpScript/wxpay/sdkpay.php"
	local args = {}
	args.notify_url = notify_url
	args.pid = pid
	args.out_trade_no = out_trade_no
	args.total_amount = total_amount
	args.name = name
	args.desc = desc
--print(TextCode.JsonEncode(args))

    local oRet = ReqEx.SubReq(url, {}, TextCode.JsonEncode(args), ngx.HTTP_POST)
    if oRet.status == ngx.HTTP_OK then
		return TextCode.JsonDecode(oRet.body)
	else
		return {code = RetCode.Failed[1], message = RetCode.Failed[2], result = oRet.status}
    end
end

function CWxPay:WxPayQRNotify(content)
	--print("CWxPay.WxPayQRNotify content: ", content)
	local success = "SUCCESS"
	local failed  = "FAIL"
	local retFormat = "<xml> <return_code><![CDATA[%s]]></return_code> <return_msg><![CDATA[%s]]></return_msg> </xml>"
    local data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil, verify = string.format(retFormat, failed, "unknown")}

	local url = "/PhpScript/wxpay/qrnotify.php" -- 同server段的子请求不能发送body数据？？？
    local oRet = ReqEx.SubReq(url, {}, content, ngx.HTTP_POST)
    if oRet.status ~= ngx.HTTP_OK then
    	data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil, verify = string.format(retFormat, failed, "http:" .. oRet.status)}
    	print("CWxPay.WxPayQRNotify data: ", data)
    	return data
    end
	data = TextCode.JsonDecode(oRet.body)
	--print("CWxPay.WxPayQRNotify data: ", data)
	return data
end
