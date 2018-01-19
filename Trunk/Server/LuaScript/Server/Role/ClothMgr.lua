-- ClothMgr 面料管理
module("ClothMgr", package.seeall)

-- 获取面料的条数
function GetClothCnt(oRole)
	assert(oRole:IsClass(CRole) and oRole.m_Init, "oRole is not validate !")
	local uid, token = oRole.m_uid, oRole.m_token

	local args = {}
	args.action = "GetAllClothInfoCnt"
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

-- 面料条数是否在限制条件之内(未超出限制)
function IsFitLimitCnt(oRole)
	-- 能否同步
	local data = CanSync(oRole)
	if data.code ~= RetCode.Success[1] then
		return data
	end
	local tLimit = data.result
	local nLimitCnt = tLimit.AddCloth
	-- 同步数据的限制
	if nLimitCnt == -1 then
		-- 无限制
		data = {code = RetCode.Success[1], message = RetCode.Success[2], result = nil}
	elseif nLimitCnt == 0 then
		-- 非会员，限制
		data = {code = RetCode.OverClothLimit[1], message = RetCode.OverClothLimit[2], result = nil}
	elseif nLimitCnt > 0 then
		-- 会员，条数限制
		data = GetClothCnt(oRole)
		if data.code == RetCode.Success[1] then
			if tonumber(data.result) >= nLimitCnt then
				data = {code = RetCode.OverClothLimit[1], message = RetCode.OverClothLimit[2], result = nil}
			else
				data = {code = RetCode.Success[1], message = RetCode.Success[2], result = nil}
			end
		end
	end
	return data
end

-- 获取用户所有标签信息
function GetAllTag(oRole, bForce)
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
	args.action = "GetAllTag"
	args.uid = uid
	args.token = token
	return ReqEx.ReqDBS(args, nil)
end

-- 增加一个 tag 标签
function AddTag(oRole, cid, name, time, mtime, bForce)
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

	mtime = tonumber(mtime) or os.time()
	local args = {}
	args.action = "AddTag"
	args.uid = uid
	args.token = token
	args.cid = cid
	args.name = name
	args.mtime = mtime
	args.time = time

	local data = ReqEx.ReqDBS(args)
	data = TextCode.JsonDecode(data)
	if type(data) == 'table' and data.code == RetCode.Success[1] then
		oRole:LogNormal(LogDef.EventType.AddTag, TextCode.JsonEncode({name=name,guid=data.result.guid}))
	end
	return data
end

-- 删除一个标签
function DelTag(oRole, guid, bForce)
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
	args.action = "DelTag"
	args.uid = uid
	args.token = token
	args.guid = guid

	local data = ReqEx.ReqDBS(args)
	data = TextCode.JsonDecode(data)
	if type(data) == 'table' and data.code == RetCode.Success[1] then
		oRole:LogNormal(LogDef.EventType.DelTag, TextCode.JsonEncode({guid=guid}))
	end
	return data
end

-- 修改标签名字
function UpdateTag(oRole, guid, name, time, mtime, bForce)
	assert(oRole:IsClass(CRole) and oRole.m_Init, "oRole is not validate !")
	local uid, token = oRole.m_uid, oRole.m_token

	mtime = tonumber(mtime) or os.time()
	local args = {}
	args.action = "UpdateTag"
	args.uid = uid
	args.token = token
	args.guid = guid
	args.name = name
	args.time = time
	args.mtime = mtime

	-- 限制条件
	if bForce ~= true then
		-- 能否同步
		local data = CanSync(oRole)
		if data.code ~= RetCode.Success[1] then
			return data
		end
	end

	local data = ReqEx.ReqDBS(args)
	data = TextCode.JsonDecode(data)
	if type(data) == 'table' and data.code == RetCode.Success[1] then
		oRole:LogNormal(LogDef.EventType.UpdateTag, TextCode.JsonEncode({name=name,guid=guid}))
	end
	return data
end

-- 查询一个标签
function QueryTag(oRole, guid, bForce)
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
	args.action = "QueryTag"
	args.uid = uid
	args.token = token
	args.guid = guid
	return ReqEx.ReqDBS(args, nil)
end

-----------------------------------------
-- 获取所有面料信息
function GetAllClothInfo (oRole, bForce)
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
	args.action = "GetAllClothInfo"
	args.uid = uid
	args.token = token
	return ReqEx.ReqDBS(args, nil)
end

-- 下载面料
function DownloadCloth (oRole, guid, bForce)
	assert(oRole:IsClass(CRole) and oRole.m_Init, "oRole is not validate !")
	local uid, token = oRole.m_uid, oRole.m_token

	-- 限制条件
	if bForce ~= true then
		-- 能否同步
		local data = CanSync(oRole)
		if data.code ~= RetCode.Success[1] then
			return nil
		end
	end

	-- DBS
	local args = {}
	args.action = "QueryCloth"
	args.uid = uid
	args.token = token
	args.guid = guid
	local ret = ReqEx.ReqDBS(args, nil)
	local data = TextCode.JsonDecode(ret)
	if type(data) ~= 'table' or data.code ~= RetCode.Success[1] then
		return nil
	end
	-- FLS
	args = {}
	args.action = "GetCloth"
	args.uid = uid
	args.name = data.result.path
	ret = ReqEx.ReqFLS(args, nil)
    --ngx.header["Content-Type"] = nil
    ngx.header["Content-Type"] = "application/octet-stream"
    ngx.header["Content-Length"] = string.len(ret)
	return ret
end

-- 添加一条面料信息
function AddCloth (oRole, name, tag, mtime, time, scaleX, scaleY, cid, extra, picData, bForce)
	assert(oRole:IsClass(CRole) and oRole.m_Init, "oRole is not validate !")
	local uid, token = oRole.m_uid, oRole.m_token

	if bForce ~= true then
		-- 面料条数是否在限制条件之内(未超出限制)
		local data = IsFitLimitCnt(oRole)
		if data.code ~= RetCode.Success[1] then
			return data
		end
	end

	-- FLS
	local args = {}
	args.action = "AddCloth"
	args.uid = uid
	local ret = ReqEx.ReqFLS(args, picData, ngx.HTTP_POST)
	local data = TextCode.JsonDecode(ret)
	if type(data) ~= 'table' or data.code ~= RetCode.Success[1] then
		return {code = RetCode.Failed[1], message = RetCode.Failed[2], result = ret}
	end
	-- DBS
	args = {}
	args.action = "AddCloth"
	args.uid = uid
	args.token = token
	args.name = name
	args.tag = tag
	args.mtime = tonumber(mtime) or os.time()
	args.time = time
	args.scaleX = scaleX
	args.scaleY = scaleY
	args.cid = cid
	args.extra = extra
	args.path = data.result

	data = ReqEx.ReqDBS(args)
	data = TextCode.JsonDecode(data)
	if type(data) == 'table' and data.code == RetCode.Success[1] then
		oRole:LogNormal(LogDef.EventType.AddCloth, TextCode.JsonEncode({name=name,guid=data.result.guid}))
	end
	return data
end

-- 删除一条面料信息
function DelCloth (oRole, guid, bForce)
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

	-- DBS
	local args = {}
	args.action = "DelCloth"
	args.uid = uid
	args.token = token
	args.guid = guid
	local ret = ReqEx.ReqDBS(args, nil)
	local data = TextCode.JsonDecode(ret)
	if data.code ~= RetCode.Success[1] then
		return data
	end
	-- FLS
	args = {}
	args.action = "DelCloth"
	args.uid = uid
	args.name = data.result.path
	ReqEx.ReqFLS(args, nil)

	-- 记录 log
	if type(data) == 'table' and data.code == RetCode.Success[1] then
		oRole:LogNormal(LogDef.EventType.DelCloth, TextCode.JsonEncode({guid=guid}))
	end
	return data
end

-- 查询一条面料信息
function QueryCloth (oRole, guid, bForce)
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
	args.action = "QueryCloth"
	args.uid = uid
	args.token = token
	args.guid = guid
	return ReqEx.ReqDBS(args, nil)
end

-- 更新面料信息（名字、标签、缩放系数、额外数据等）
function UpdateCloth(oRole, guid, mtime, name, tag, scaleX, scaleY, extra, picData, bForce)
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

	local data, args, path, oldPath = nil, nil, nil, nil
	-- 是否需要更新面料图片
	local isModPic = (type(picData) == 'string' and #picData > 0)

	-- 如果需要更新面料图片，就先增加一个面料图片到文件服务器
	if isModPic then
		-- DBS  QueryCloth
		args = {}
		args.action = "QueryCloth"
		args.uid = uid
		args.token = token
		args.guid = guid
		data = ReqEx.ReqDBS(args, nil)
		data = TextCode.JsonDecode(data)
		if type(data) ~= 'table' or data.code ~= RetCode.Success[1] then
			return data
		end
		oldPath = data.result.path
		-- FLS  AddCloth
		args = {}
		args.action = "AddCloth"
		args.uid = uid
		local ret = ReqEx.ReqFLS(args, picData, ngx.HTTP_POST)
		data = TextCode.JsonDecode(ret)
		if type(data) ~= 'table' or data.code ~= RetCode.Success[1] 
			or type(data.result) ~= 'string' or #data.result <= 0 then
			return {code = RetCode.Failed[1], message = RetCode.Failed[2], result = ret}
		end
		path = data.result
	end
	-- DBS  UpdateCloth
	mtime = tonumber(mtime) or os.time()
	args = {}
	args.action = "UpdateCloth"
	args.uid = uid
	args.token = token
	args.guid = guid
	args.mtime = mtime
	args.name = name
	args.tag = tag
	args.scaleX = scaleX
	args.scaleY = scaleY
	args.extra = extra
	args.path = path
	data = ReqEx.ReqDBS(args)
	data = TextCode.JsonDecode(data)

	-- 成功后要删除以前的面料图片，失败要删除刚刚加入的新面料图片。成功后还有加入log
	if type(data) == 'table' and data.code == RetCode.Success[1] then
		if isModPic and path and oldPath then
			-- FLS  DelCloth
			args = {}
			args.action = "DelCloth"
			args.uid = uid
			args.name = oldPath
			ReqEx.ReqFLS(args, nil)
		end
		-- Logs
		oRole:LogNormal(LogDef.EventType.UpdateCloth, TextCode.JsonEncode({name=name,tag=tag,guid=guid}))
	else
		if isModPic and path then
			-- FLS  DelCloth
			args = {}
			args.action = "DelCloth"
			args.uid = uid
			args.name = path
			ReqEx.ReqFLS(args, nil)
		end
	end
	return data
end
