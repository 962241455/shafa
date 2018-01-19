-- PayMgr
module("PayMgr", package.seeall)

local PayConfig = _G["PayCfg"].PayConfig
local ProductCfg = _G["PayCfg"].ProductCfg

-- 同步支付配置
function SyncPayCfg(oRole)
	assert(oRole:IsClass(CRole) and oRole.m_Init, "oRole is not validate !")
	local uid, token = oRole.m_uid, oRole.m_token

	data = {code = RetCode.Success[1], message = RetCode.Success[2], result = PayConfig}
	return data
end

-- 查询订单
function QueryTrade(oRole, trade_no)
	assert(oRole:IsClass(CRole) and oRole.m_Init, "oRole is not validate !")
	local uid, token = oRole.m_uid, oRole.m_token

	local args = {}
	args.action = "QueryTrade"
	args.uid = uid
	args.token = token
	args.trade_no = trade_no
	local data = TextCode.JsonDecode(ReqEx.ReqDBS(args, nil))
	if data.code == RetCode.Success[1] then
		local trade = data.result
		local user = oRole:GetDBInfo()
		data.result = {trade = trade, user = user}
	end
	return data
end

-- 增加订单
function AddTrade(oRole, trade_no, currTime, pid, payway, paymod)
	assert(oRole:IsClass(CRole) and oRole.m_Init, "oRole is not validate !")
	local uid, token = oRole.m_uid, oRole.m_token

	if not pid or not ProductCfg[pid] then
		return {code = RetCode.Failed[1], message = RetCode.Failed[2], result = "not exist pid: " .. tostring(pid)}
	end

	-- 访问 DBS
	local tExtra = {}
	tExtra.payway = payway
	tExtra.paymod = paymod
	tExtra.platID = oRole.m_platID
    tExtra.sVersion = oRole.m_sVersion
    tExtra.cVersion = oRole.m_cVersion
	local args = {}
	args.action = "AddTrade"
	args.uid = uid
	args.token = token
	args.trade_no = trade_no
	args.pid = pid
	args.cre_time = currTime
	args.extra = TextCode.JsonEncode(tExtra)
	args.type = 1
	args.amount = ProductCfg[pid].pprice
	args.add_time = ProductCfg[pid].add_time
	local data = ReqEx.ReqDBS(args, nil)
	data = TextCode.JsonDecode(data)

	if data.code == RetCode.Success[1] then
		-- 创建交易订单
		oRole:LogCharge(LogDef.EventType.AddTrade, trade_no, currTime, pid, ProductCfg[pid].pprice, payway, paymod)
	end

	return data
end

-- 完成订单
function FinishTrade(trade_no, total_amount)
	assert(trade_no and total_amount, "FinishTrade args nil")
	local done_time = os.time()
	local args = {}
	args.action = "FinishTrade"
	args.trade_no = trade_no
	args.done_time = done_time
	local data = ReqEx.ReqDBS(args, nil)
	data = TextCode.JsonDecode(data)

	if data.code == RetCode.Success[1] then
		local tExtra = TextCode.JsonDecode(data.result.extra)
	    -- 创建角色
	    local oRole = CRole:new()
	    oRole:Init(data.result.uid, nil, tExtra.cVersion, tExtra.sVersion, tExtra.platID, "FinishTrade")

		-- 完成交易订单的log
		oRole:LogCharge(LogDef.EventType.FinishTrade, trade_no, data.result.cre_time, data.result.pid, total_amount, tExtra.payway, tExtra.paymod)
		-- 增加vip时间的log
		oRole:LogNormal(LogDef.EventType.AddVipTime, TextCode.JsonEncode({add_time=data.result.add_time}))
	end
	
	return data
end

-- 支付接口
function Pay(oRole, pid, payway, paymod)
	assert(oRole:IsClass(CRole) and oRole.m_Init, "oRole is not validate !")
	local uid, token, user, rtype = oRole.m_uid, oRole.m_token, oRole.m_user, oRole.m_type

	local data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}
	if not pid or not ProductCfg[pid] then
		data.result = "not exist pid: " .. tostring(pid)
		return data
	end
	if rtype == RoleDef.UserType.User then
		-- 个人账户充值
		if ProductCfg[pid].group ~= RoleDef.PayGroup.Person then
			return data
		end
	elseif rtype == RoleDef.UserType.Com then
		-- 企业账户充值
		if ProductCfg[pid].group ~= RoleDef.PayGroup.Company then
			return data
		end
		-- 企业子账户中的管理员账号才有权限充值
		data = AccountAuthMgr.IsComOwner(oRole)
	    if data.code ~= RetCode.Success[1] then
	        return data
	    end
	else
		return data
	end
	--print("pid: ", ProductCfg[pid])

	local alipay_notify_url = _G["ServCfg"]["alipay_notify_url"]
	local wxpay_notify_url  = _G["ServCfg"]["wxpay_notify_url"]

	local currTime = os.time()
	local timestmp = os.date("%Y%m%d%H%M%S", currTime)
	local out_trade_no = timestmp .. uid
	local total_amount = ProductCfg[pid].pprice
	local name = ProductCfg[pid].name
	local desc = ProductCfg[pid].desc
	
	local pmid = paymod
	local pwid = nil
	if payway == "alipay" then
		pwid = RoleDef.PayWay.AliPay
	elseif payway == "weixin" then
		pwid = RoleDef.PayWay.WeiXin
	else
		assert(false, "unsupport PayWay: " .. tostring(payway))
	end

	local qr_code = ""
	local sdk_order = ""
	if pwid == RoleDef.PayWay.AliPay then
		if pmid == RoleDef.PayMod.QR then
			-- 使用支付宝预下单 (二维码支付)
			data = ApiPayMgr.AliPayQR(alipay_notify_url, pid, out_trade_no, total_amount, name, desc)
			if data.code == RetCode.Success[1] then
				qr_code = data.result.qr_code
			end
		elseif pmid == RoleDef.PayMod.SDK then
			-- 使用支付宝sdk支付
			data = ApiPayMgr.AliPaySDK(alipay_notify_url, pid, out_trade_no, total_amount, name, desc)
			if data.code == RetCode.Success[1] then
				sdk_order = data.result
			end
		else
			assert(false, "unsupport AliPay PayMod: " .. tostring(paymod))
		end
	elseif pwid == RoleDef.PayWay.WeiXin then
		if pmid == RoleDef.PayMod.QR then
			-- 使用微信二维码支付
			data = ApiPayMgr.WxPayQR(wxpay_notify_url, pid, out_trade_no, total_amount, name, desc)
			if data.code == RetCode.Success[1] then
				qr_code = data.result.code_url
			end
		elseif pmid == RoleDef.PayMod.SDK then
			-- 使用微信sdk支付
			data = ApiPayMgr.WxPaySDK(wxpay_notify_url, pid, out_trade_no, total_amount, name, desc)
			if data.code == RetCode.Success[1] then
				sdk_order = data.result
			end
		else
			assert(false, "unsupport WxPay PayMod: " .. tostring(paymod))
		end
	else
		assert(false, "unsupport PayWay: " .. tostring(payway))
	end

	local ext_pay_info = data.result

	if data.code ~= RetCode.Success[1] then
		return data
	else
		-- 服务器增加一个订单
		data = AddTrade(oRole, out_trade_no, currTime, pid, pwid, pmid)
		if data.code == RetCode.Success[1] then
			assert(pid == data.result.pid)
			data.result.payway = payway
			data.result.paymod = paymod
			data.result.qr_code = qr_code
			data.result.sdk_order = sdk_order
			data.result.ext_pay_info = ext_pay_info
		end
		return data
	end
end

-- 支付宝 二维码支付到账 异步回调通知。
function AliPayQRNotify(out_trade_no, total_amount)
	--print("PayMgr.AliPayQRNotify: ", out_trade_no, total_amount)
	return FinishTrade(out_trade_no, total_amount)
end

-- 微信 二维码支付到账 异步回调通知。
function WxPayQRNotify(out_trade_no, total_amount)
	--print("PayMgr.WxPayQRNotify: ", out_trade_no, total_amount)
	return FinishTrade(out_trade_no, total_amount)
end
