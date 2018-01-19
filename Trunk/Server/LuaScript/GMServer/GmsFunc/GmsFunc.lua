-- GmsFunc
module("GmsFunc", package.seeall)

-- 获取 Gms 的 MysqlFunc 对象
function GetGmsMyFunc()
    local cfg = _G["ServCfg"]["GMSMysqlCfg"]
    local oFunc = MyFunc:new(cfg.gms_host, cfg.gms_port, 
        cfg.gms_user, cfg.gms_pwd, cfg.gms_db, cfg.gms_keepTime, cfg.gms_ConnNum)
    return oFunc
end


-- 查询所有GM账号
function GetAllGM()
	local oMyFunc = GetGmsMyFunc()
	local data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}

	local ret, err = GmsSqlStmt.GetAllGM(oMyFunc)
	if ret then
		data = {code = RetCode.Success[1], message = RetCode.Success[2], result = ret}
	else
		data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = err}
	end

	oMyFunc:freeInstance()
	return data
end

-- 查询某个GM
function QueryGM(name)
	local oMyFunc = GetGmsMyFunc()
	local data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}

	local ret, err = GmsSqlStmt.QueryGM(oMyFunc, name)
	if ret then
		data = {code = RetCode.Success[1], message = RetCode.Success[2], result = ret}
	else
		data = {code = RetCode.NoAccount[1], message = RetCode.NoAccount[2], result = err}
	end

	oMyFunc:freeInstance()
	return data
end

-- 增加GM账号
function AddGM(name, pass, power, token)
	local oMyFunc = GetGmsMyFunc()
	local data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}

	local ret, err = GmsSqlStmt.AddGM(oMyFunc, name, pass, power, token)
	if ret and not err then
		ret, err = GmsSqlStmt.QueryGM(oMyFunc, name)
	end
	if ret then
		data = {code = RetCode.Success[1], message = RetCode.Success[2], result = ret}
	else
		data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = err}
	end

	oMyFunc:freeInstance()
	return data
end

-- 删除GM账号
function DelGM(name)
	local oMyFunc = GetGmsMyFunc()
	local data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}

	local ret, err = GmsSqlStmt.DelGM(oMyFunc, name)
	ret, err = GmsSqlStmt.QueryGM(oMyFunc, name)
	if not ret then
		data = {code = RetCode.Success[1], message = RetCode.Success[2], result = {name = name}}
	else
		data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = err}
	end

	oMyFunc:freeInstance()
	return data
end

-- 修改GM账号信息
function ModGM(name, pass, power, token)
	local oMyFunc = GetGmsMyFunc()
	local data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}

	local ret, err = GmsSqlStmt.ModGM(oMyFunc, name, pass, power, token)
	ret, err = GmsSqlStmt.QueryGM(oMyFunc, name)
	if ret then
		data = {code = RetCode.Success[1], message = RetCode.Success[2], result = ret}
	else
		data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = err}
	end

	oMyFunc:freeInstance()
	return data
end
