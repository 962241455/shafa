-- PayMgr
module("ApiPayMgr", package.seeall)

-- 支付宝 预下单 二维码 支付。
function AliPayQR(notify_url, pid, out_trade_no, total_amount, name, desc)
	local aliPay = CAliPay:new()
	local data = aliPay:AliPayQR(notify_url, pid, out_trade_no, total_amount, name, desc)
	return data
end

-- 支付宝 SDK 支付。
function AliPaySDK(notify_url, pid, out_trade_no, total_amount, name, desc)
	local aliPay = CAliPay:new()
	local data = aliPay:AliPaySDK(notify_url, pid, out_trade_no, total_amount, name, desc)
	return data
end

-- 支付宝 预下单 二维码 支付 回调通知。
function AliPayQRNotify(content)
	local aliPay = CAliPay:new()
	local data = aliPay:AliPayQRNotify(content)
	if data.code ~= RetCode.Success[1] then
		return "failed"
	else
		local tRet = data.result or {}
		--[[
		local args = {}
		args.out_trade_no = tRet["out_trade_no"]
		args.total_amount = tRet["total_amount"]
		args.trade_status = tRet["trade_status"]
		args.app_id = tRet["app_id"]
		args.seller_id = tRet["seller_id"]
		--]]
		if tRet["notify_type"] == "trade_status_sync" then
			if tRet["trade_status"] == "TRADE_SUCCESS" or tRet["trade_status"] == "TRADE_FINISHED" then
				-- 支付成功
				PayMgr.AliPayQRNotify(tRet["out_trade_no"], tRet["total_amount"])
			elseif tRet["trade_status"] == "TRADE_CLOSED" then
				-- 支付关闭
			elseif tRet["trade_status"] == "WAIT_BUYER_PAY" then
				-- 创建支付，等待付款
			else
				-- 没有其他的了
			end
		else
			print("CAliPay.AliPayQRNotify -- notify_type: ", tRet["notify_type"])
		end

		return "success"
	end
end

-- 微信 二维码 支付。
function WxPayQR(notify_url, pid, out_trade_no, total_amount, name, desc)
	local wxPay = CWxPay:new()
	local data = wxPay:WxPayQR(notify_url, pid, out_trade_no, total_amount, name, desc)
	return data
end

-- 微信 SDK 支付。
function WxPaySDK(notify_url, pid, out_trade_no, total_amount, name, desc)
	local wxPay = CWxPay:new()
	local data = wxPay:WxPaySDK(notify_url, pid, out_trade_no, total_amount, name, desc)
	return data
end

-- 微信支付回调
function WxPayQRNotify(content)
	local wxPay = CWxPay:new()
	local data = wxPay:WxPayQRNotify(content)
	if data.code == RetCode.Success[1] then
		-- 支付成功
		local out_trade_no = data.result["out_trade_no"]
		local total_amount = data.result["total_fee"] / 100
		PayMgr.WxPayQRNotify(out_trade_no, total_amount)
	end
	return data.verify
end
