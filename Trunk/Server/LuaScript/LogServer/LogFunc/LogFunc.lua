-- LogFunc
module("LogFunc", package.seeall)

-- 获取 Log 的 MysqlFunc 对象
function GetLogMyFunc()
    local cfg = _G["ServCfg"]["LogMysqlCfg"]
    local oFunc = MyFunc:new(cfg.log_host, cfg.log_port, 
        cfg.log_user, cfg.log_pwd, cfg.log_db, cfg.log_keepTime, cfg.log_ConnNum)
    return oFunc
end

-- 普通log记录
function AddLogNormal(uid, eventType, eventReason, eventTime, platID, operator, ipAddr, sVersion, cVersion, extra)
	local oMyFunc = GetLogMyFunc()
	local data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}

	local ret, err = LogSqlStmt.AddLogNormal(oMyFunc, uid, eventType, eventReason, eventTime, platID, operator, ipAddr, sVersion, cVersion, extra)
	if not ret then
		-- 服务器错误
		data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = err}
	else
		data = {code = RetCode.Success[1], message = RetCode.Success[2], result = ret}
	end

	oMyFunc:freeInstance()
	return data
end

-- 账号log记录
function AddLogAccount(uid, eventType, eventReason, eventTime, platID, operator, ipAddr, sVersion, cVersion, location)
	local oMyFunc = GetLogMyFunc()
	local data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}

	local ret, err = LogSqlStmt.AddLogAccount(oMyFunc, uid, eventType, eventReason, eventTime, platID, operator, ipAddr, sVersion, cVersion, location)
	if not ret then
		-- 服务器错误
		data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = err}
	else
		data = {code = RetCode.Success[1], message = RetCode.Success[2], result = ret}
	end

	oMyFunc:freeInstance()
	return data
end

-- 充值log记录
function AddLogCharge(uid, eventType, eventReason, eventTime, platID, operator, ipAddr, sVersion, cVersion, tradeno, createTime, pid, amount, payway, paymod)
	local oMyFunc = GetLogMyFunc()
	local data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}

	local ret, err = LogSqlStmt.AddLogCharge(oMyFunc, uid, eventType, eventReason, eventTime, platID, operator, ipAddr, sVersion, cVersion, tradeno, createTime, pid, amount, payway, paymod)
	if not ret then
		-- 服务器错误
		data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = err}
	else
		data = {code = RetCode.Success[1], message = RetCode.Success[2], result = ret}
	end

	oMyFunc:freeInstance()
	return data
end
