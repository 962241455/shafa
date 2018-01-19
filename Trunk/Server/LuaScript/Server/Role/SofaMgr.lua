-- SofaMgr 沙发管理
module("SofaMgr", package.seeall)

-- 获取沙发模型条数
function GetSofaModelCnt(oRole)
	assert(oRole:IsClass(CRole) and oRole.m_Init, "oRole is not validate !")
	local uid, token = oRole.m_uid, oRole.m_token

	local args = {}
	args.action = "GetAllSofaModelCnt"
	args.uid = uid
	args.token = token
	local data = TextCode.JsonDecode(ReqEx.ReqDBS(args, nil))
	return data
end

-- 获取沙发配色条数
function GetSofaColorCnt(oRole)
	assert(oRole:IsClass(CRole) and oRole.m_Init, "oRole is not validate !")
	local uid, token = oRole.m_uid, oRole.m_token

	local args = {}
	args.action = "GetAllSofaColorlCnt"
	args.uid = uid
	args.token = token
	local data = TextCode.JsonDecode(ReqEx.ReqDBS(args, nil))
	return data
end

-- 是否能够同步
function CanSync(oRole)
	assert(oRole:IsClass(CRole) and oRole.m_Init, "oRole is not validate !")
	local tLimit = oRole:GetSyncLimit()

	local data = {code = RetCode.OverLimit[1], message = RetCode.OverLimit[2], result = tLimit}
	if tLimit.Sync == -1 then
		data = {code = RetCode.Success[1], message = RetCode.Success[2], result = tLimit}
	end
	return data
end

-- 沙发模型或者沙发配色 条数是否在限制条件之内(未超出限制)
function IsFitLimitCnt(oRole, ntype)
	-- 能否同步
	local data = CanSync(oRole)
	if data.code ~= RetCode.Success[1] then
		return data
	end
	local tLimit = data.result

	-- 同步数据的限制
	if ntype == RoleDef.SofaType.SofaModel then
		local nLimitCnt = tLimit.AddModel
		if nLimitCnt == -1 then
			data = {code = RetCode.Success[1], message = RetCode.Success[2], result = nil}
		elseif nLimitCnt == 0 then
			data = {code = RetCode.OverSofaModelLimit[1], message = RetCode.OverSofaModelLimit[2], result = nil}
		elseif nLimitCnt > 0 then
			data = GetSofaModelCnt(oRole)
			if data.code == RetCode.Success[1] then
				if tonumber(data.result) >= nLimitCnt then
					data = {code = RetCode.OverSofaModelLimit[1], message = RetCode.OverSofaModelLimit[2], result = nil}
				else
					data = {code = RetCode.Success[1], message = RetCode.Success[2], result = nil}
				end
			end
		end
	elseif ntype == RoleDef.SofaType.SofaColor then
		local nLimitCnt = tLimit.AddColor
		if nLimitCnt == -1 then
			data = {code = RetCode.Success[1], message = RetCode.Success[2], result = nil}
		elseif nLimitCnt == 0 then
			data = {code = RetCode.OverSofaColorLimit[1], message = RetCode.OverSofaColorLimit[2], result = nil}
		elseif nLimitCnt > 0 then
			data = GetSofaColorCnt(oRole)
			if data.code == RetCode.Success[1] then
				if tonumber(data.result) >= nLimitCnt then
					data = {code = RetCode.OverSofaColorLimit[1], message = RetCode.OverSofaColorLimit[2], result = nil}
				else
					data = {code = RetCode.Success[1], message = RetCode.Success[2], result = nil}
				end
			end
		end
	end
	return data
end

-- 增加一个 sofa 模型
function AddSofa(oRole, cid, ntype, mtime, time, name, data, icon, bForce)
	assert(oRole:IsClass(CRole) and oRole.m_Init, "oRole is not validate !")
	local uid, token = oRole.m_uid, oRole.m_token

	if type(data) ~= 'string' or #data <= 0 then
		data = "{}"
	end
	ntype = ntype or RoleDef.SofaType.SofaModel
	if ntype ~= RoleDef.SofaType.SofaModel then
		ntype = RoleDef.SofaType.SofaColor
	end
	mtime = tonumber(mtime) or os.time()
	local info = {}
	info.cid = cid
	info.type = ntype
	info.mtime = mtime
	info.time = time
	info.name = name
	info.data = TextCode.JsonEncode(TextCode.JsonDecode(data))
	info.icon = icon

	-- 沙发模型或者沙发配色 条数是否在限制条件之内(未超出限制)
	if bForce ~= true then
		local data = IsFitLimitCnt(oRole, ntype)
		if data.code ~= RetCode.Success[1] then
			return data
		end
	end

	local args = {}
	args.action = "AddSofa"
	args.uid = uid
	args.token = token
	local data = ReqEx.ReqDBS(args, TextCode.JsonEncode(info), ngx.HTTP_POST)
	data = TextCode.JsonDecode(data)
	if type(data) == 'table' and data.code == RetCode.Success[1] then
		oRole:LogNormal(LogDef.EventType.AddSofa, TextCode.JsonEncode({name=name,guid=data.result.guid}))
	end
	return data
end

-- 删除一个 sofa 模型
function DelSofa(oRole, guid, bForce)
	assert(oRole:IsClass(CRole) and oRole.m_Init, "oRole is not validate !")
	local uid, token = oRole.m_uid, oRole.m_token

	-- 限制条件
	if bForce ~= true then
		-- 能否同步
		local data = CanSync(oRole)
		if data.code ~= RetCode.Success[1] then
			return data
		end
	end

	local args = {}
	args.action = "DelSofa"
	args.uid = uid
	args.token = token
	args.guid = guid

	local data = ReqEx.ReqDBS(args)
	data = TextCode.JsonDecode(data)
	if type(data) == 'table' and data.code == RetCode.Success[1] then
		oRole:LogNormal(LogDef.EventType.DelSofa, TextCode.JsonEncode({guid=guid}))
	end
	return data
end

-- 修改一个 sofa 模型
function UpdateSofa(oRole, guid, mtime, time, name, data, icon, bForce)
	assert(oRole:IsClass(CRole) and oRole.m_Init, "oRole is not validate !")
	local uid, token = oRole.m_uid, oRole.m_token

	mtime = tonumber(mtime) or os.time()
	local info = {}
	info.guid = guid
	info.mtime = mtime
	info.time = time
	info.name = name
	info.data = data
	info.icon = icon

	-- 限制条件
	if bForce ~= true then
		-- 能否同步
		local data = CanSync(oRole)
		if data.code ~= RetCode.Success[1] then
			return data
		end
	end

	local args = {}
	args.action = "UpdateSofa"
	args.uid = uid
	args.token = token
	args.guid = guid

	local data = ReqEx.ReqDBS(args, TextCode.JsonEncode(info), ngx.HTTP_POST)
	data = TextCode.JsonDecode(data)
	if type(data) == 'table' and data.code == RetCode.Success[1] then
		oRole:LogNormal(LogDef.EventType.UpdateSofa, TextCode.JsonEncode({name=name,guid=guid}))
	end
	return data
end

-- 查询一个 sofa 模型
function QuerySofa(oRole, guid, bForce)
	assert(oRole:IsClass(CRole) and oRole.m_Init, "oRole is not validate !")
	local uid, token = oRole.m_uid, oRole.m_token

	-- 限制条件
	if bForce ~= true then
		-- 能否同步
		local data = CanSync(oRole)
		if data.code ~= RetCode.Success[1] then
			return data
		end
	end

	local args = {}
	args.action = "QuerySofa"
	args.uid = uid
	args.token = token
	args.guid = guid
	return ReqEx.ReqDBS(args)
end

-- 查询用户所有 sofa 模型
function GetAllSofa(oRole, bForce)
	assert(oRole:IsClass(CRole) and oRole.m_Init, "oRole is not validate !")
	local uid, token = oRole.m_uid, oRole.m_token

	-- 限制条件
	if bForce ~= true then
		-- 能否同步
		local data = CanSync(oRole)
		if data.code ~= RetCode.Success[1] then
			return data
		end
	end

	local args = {}
	args.action = "GetAllSofa"
	args.uid = uid
	args.token = token
	return ReqEx.ReqDBS(args)
end
