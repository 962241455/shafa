-- 到Log服务端的协议
_G["S2LogS"] = {}


-- 普通log记录
S2LogS.AddLogNormal = function (args, body, bodyFile)
	local uid = tonumber(args.uid)
	local eventType, eventReason, eventTime = tonumber(args.eventType), args.eventReason, tonumber(args.eventTime)
	local platID, operator, ipAddr = tonumber(args.platID), args.operator, args.ipAddr
	local sVersion, cVersion, extra = args.sVersion, args.cVersion, args.extra or ""
	return LogFunc.AddLogNormal(uid, eventType, eventReason, eventTime, platID, operator, ipAddr, sVersion, cVersion, extra)
end

-- 账号log记录
S2LogS.AddLogAccount = function (args, body, bodyFile)
	local uid = tonumber(args.uid)
	local eventType, eventReason, eventTime = tonumber(args.eventType), args.eventReason, tonumber(args.eventTime)
	local platID, operator, ipAddr = tonumber(args.platID), args.operator, args.ipAddr
	local sVersion, cVersion, location = args.sVersion, args.cVersion, args.location or ""
	return LogFunc.AddLogAccount(uid, eventType, eventReason, eventTime, platID, operator, ipAddr, sVersion, cVersion, location)
end

-- 充值log记录
S2LogS.AddLogCharge = function (args, body, bodyFile)
	local uid = tonumber(args.uid)
	local eventType, eventReason, eventTime = tonumber(args.eventType), args.eventReason, tonumber(args.eventTime)
	local platID, operator, ipAddr = tonumber(args.platID), args.operator, args.ipAddr
	local sVersion, cVersion = args.sVersion, args.cVersion
	local tradeno, createTime, pid = args.tradeno, tonumber(args.createTime), args.pid
	local amount, payway, paymod = tonumber(args.amount), tonumber(args.payway), tonumber(args.paymod)
	return LogFunc.AddLogCharge(uid, eventType, eventReason, eventTime, platID, operator, ipAddr, sVersion, cVersion, tradeno, createTime, pid, amount, payway, paymod)
end
