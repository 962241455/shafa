-- GMRole
-- 角色类
function CGMRole:Ctor()
	self.name = nil
	self.pass = nil
	self.power = nil
	self.token = nil
	self.date = nil
end

-- 初始化
function CGMRole:Init(name, pass, token, power, date)
	self.name = name
	self.pass = pass
	self.token = token
	self.power = tonumber(power)
	self.date = date
end

-- 获取数据
function CGMRole:GetInfo()
	local gmInfo = {}
	gmInfo.name = self.name
	gmInfo.pass = self.pass
	gmInfo.token = self.token
	gmInfo.power = self.power
	gmInfo.date = self.date

	return gmInfo
end

-- 获取某个权限能够执行的 GM指令列表
function CGMRole:GetGMList()
	local power = self.power
    local gmList = {}
    if power >= 0 then
        for i, v in pairs(GMDef.GMList) do 
            if v.power >= power and not v.notShow then
                gmList[i] = v
            end
        end
    end
    return gmList
end

-- 获取GM 账号信息、GMList
function CGMRole:GMGetData()
	local gmInfo = self:GetInfo()
	local gmList = self:GetGMList()
	local gmData = {gmInfo = gmInfo, gmList = gmList}
	return gmData
end

-- 获取某条GM指令的详细信息，包括参数、权限、子命令
function CGMRole:GMGetCmdInfo(cmd)
	if type(cmd) == 'string' and #cmd > 0 then
		return GMDef.GMList[cmd]
	else
		return nil
	end
end

-- 生成token
function CGMRole:GenToken()
    return '' .. (10000000 + (LuaEx.Random() % 89999999))
end

-- 更新GM的token令牌
function CGMRole:UpdateToken()
    local data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}
    local newToken = self:GenToken()
    if self.name == GMDef.SuperGM.name then
    	--GMDef.SuperGM.token = newToken
        data = {code = RetCode.Success[1], message = RetCode.Success[2], result = GMDef.SuperGM}
    else
        data = GmsFunc.ModGM(self.name, nil, nil, newToken)
    end
    if data.code == RetCode.Success[1] then
        self.token = data.result.token
    end
    return data
end

-- 修改GM密码
function CGMRole:GMModPwd(dstPass)
    local data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}
    if type(dstPass) == 'string' and #dstPass > 0 then
    	pass = TextCode.Md5Encode(dstPass)
        data = GmsFunc.ModGM(self.name, pass, nil, nil)
    end
    return data
end

-- 获取所有GM账号
function CGMRole:AllGM()
    local data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}
	if self.power <= GMDef.GMList["AllGM"].power then
		data = GmsFunc.GetAllGM()
	end
	return data
end

-- 增加一个GM账号
function CGMRole:AddGM(dstName, dstPass, dstPower)
	dstPass  = TextCode.Md5Encode(dstPass)
	dstPower = tonumber(dstPower) or GMDef.GMNormalPower

    local data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}
	if self.power <= GMDef.GMList["AddGM"].power and self.power < dstPower then
		local dstToken = self:GenToken()
		data = GmsFunc.AddGM(dstName, dstPass, dstPower, dstToken)
	end
	return data
end

-- 删除一个GM账号
function CGMRole:DelGM(dstName)
    local data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}
	if self.power <= GMDef.GMList["DelGM"].power then
		data = GMMgr.QueryGM(dstName)
		if data.code == RetCode.Success[1] and self.power < data.result.power then
			data = GmsFunc.DelGM(dstName)
		end
	end
	return data
end

-- 修改一个GM账号
function CGMRole:ModGM(dstName, dstPass, dstPower)
	if type(dstPass) == 'string' and #dstPass > 0 then
		dstPass  = TextCode.Md5Encode(dstPass)
	else
		dstPass = nil
	end
	dstPower = tonumber(dstPower)

    local data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}
	if self.power <= GMDef.GMList["ModGM"].power and self.power < (dstPower or GMDef.GMPowerRange[2]) then
		data = GMMgr.QueryGM(dstName)
		if data.code == RetCode.Success[1] and self.power < data.result.power then
			data = GmsFunc.ModGM(dstName, dstPass, dstPower, nil)
		end
	end
	return data
end

