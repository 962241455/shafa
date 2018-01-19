
-- 支付宝 支付。构造函数
function CAliPay:Ctor()
	--
end

-- 支付宝 预下单 二维码支付。
function CAliPay:AliPayQR(notify_url, pid, out_trade_no, total_amount, name, desc)
	local args = {}
	args.notify_url = notify_url
	args.pid = pid
	args.out_trade_no = out_trade_no
	args.total_amount = total_amount
	args.subject = name -- "订单标题"
	args.body = desc --"订单描述"
--print(TextCode.JsonEncode(args))

	local url = "/PhpScript/alipay/QRPay/qrpay.php"
	--local url = "/proxy/http/127.0.0.1:9101/PhpScript/alipay/QRPay/qrpay.php"
    local oRet = ReqEx.SubReq(url, {}, TextCode.JsonEncode(args), ngx.HTTP_POST)
    if oRet.status == ngx.HTTP_OK then
		return TextCode.JsonDecode(oRet.body)
	else
		return {code = RetCode.Failed[1], message = RetCode.Failed[2], result = oRet}
    end
end

-- 支付宝 sdk 支付。
function CAliPay:AliPaySDK(notify_url, pid, out_trade_no, total_amount, name, desc)
	local args = {}
	args.notify_url = notify_url
	args.pid = pid
	args.out_trade_no = out_trade_no
	args.total_amount = total_amount
	args.subject = name -- "订单标题"
	args.body = desc --"订单描述"
--print(TextCode.JsonEncode(args))

	local url = "/PhpScript/alipay/QRPay/sdkpay.php"
	--local url = "/proxy/http/127.0.0.1:9101/PhpScript/alipay/QRPay/qrpay.php"
    local oRet = ReqEx.SubReq(url, {}, TextCode.JsonEncode(args), ngx.HTTP_POST)
    if oRet.status == ngx.HTTP_OK then
		return TextCode.JsonDecode(oRet.body)
	else
		return {code = RetCode.Failed[1], message = RetCode.Failed[2], result = oRet}
    end
end

-- 二维码支付 异步回调通知
function CAliPay:AliPayQRNotify(content)
	local url = "/PhpScript/alipay/QRPay/qrnotify.php" -- 同server段的子请求不能发送body数据？？？
	--local url = "/proxy/http/127.0.0.1:9101/PhpScript/alipay/QRPay/qrnotify.php"
    local oRet = ReqEx.SubReq(url, {}, content, ngx.HTTP_POST)

    local data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = ""}
    if oRet.status ~= ngx.HTTP_OK then
    	print("CAliPay.AliPayQRNotify: ", oRet, content)
    	data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = oRet}
		return data
    end
	local ret = TextCode.JsonDecode(oRet.body)
	if ret.code ~= RetCode.Success[1] or ret.result ~= true then
    	print("CAliPay.AliPayQRNotify: ", oRet, content)
    	data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = oRet}
		return data
	end
	-- 验签成功
	local tRet = ngx.decode_args(content) or {}
	data = {code = RetCode.Success[1], message = RetCode.Success[2], result = tRet}
	return data
end
