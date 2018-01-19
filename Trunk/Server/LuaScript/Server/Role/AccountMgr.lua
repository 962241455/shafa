-- AccountMgr
module("AccountMgr", package.seeall)

-- 口令
local TokenExpireTime = 12 * 3600 	-- 口令过期时间，12个小时
-- 短信验证码
local ExpiredTime  = 600 	-- 短信验证码过期时间，单位 秒
local IntervalTime = 60 	-- 短信验证码间隔时间，单位 秒

-- 不同版本号，对于密码的保护措施不同
function DecodePwd(pass)
    return VersionMgr.DecodePwd(pass)
end

--  客户端是否为 IOS 审核版本
function IsIosReview()
    return VersionMgr.IsIosReview()
end

-- 生成口令 Token
function GenToken()
	return 10000000 + (LuaEx.Random() % 89999999)
end

-- 查询符合条件用户数据
function QueryUser(uid, token, user, pass, rtype, status, owner_uid, nick)
    local args = {}
    args.action = "QueryUser"
    args.uid = uid
    args.token = token
    args.user = user
    args.pass = pass
    args.type = rtype
    args.status = status
    args.owner_uid = owner_uid
    args.nick = nick
    local data = TextCode.JsonDecode(ReqEx.ReqDBS(args, nil))
    return data
end

-- 使用user或者uid查询用户数据，若传入user，则以user为准。
function QueryAccount(user, uid)
    local args = {}
    args.action = "QueryAccount"
    args.user = user
    args.uid = uid
    local data = TextCode.JsonDecode(ReqEx.ReqDBS(args, nil))
    return data
end

-- 使用uid、token查询用户数据。
function AccountQueryID(uid, token)
	local args = {}
	args.action = "AccountQueryID"
	args.uid = uid
	args.token = token
	local data = TextCode.JsonDecode(ReqEx.ReqDBS(args, nil))
	return data
end

-- 更新 令牌
function UpdateToken(user, uid)
    local args = {}
    args.action = "UpdateToken"
    args.user = user
    args.uid = uid
	args.currTime = os.time()
	args.expiredTime = TokenExpireTime
	args.newToken = GenToken()
    local data = TextCode.JsonDecode(ReqEx.ReqDBS(args, nil))
    return data
end

-- 账号注册，内部函数，只适合个人账户、游客账户
local function InnerRegister (oRole, rtype, user, pass, nick)
	if type(rtype) ~= 'number' or (rtype ~= RoleDef.UserType.User and rtype ~= RoleDef.UserType.Guest) then
		assert(false, "InnerRegister: type error!")
	end
	if type(user) ~= 'string' or #user <= 0 then
		assert(false, "InnerRegister: user error!")
	end
	if type(pass) ~= 'string' or #pass <= 0 then
		assert(false, "InnerRegister: pass error!")
	end
	if type(nick) ~= 'string' or #nick <= 0 then
		assert(false, "InnerRegister: nick error!")
	end

	local data = nil
	local currTime, head = os.time(), ""

    -- 注册
	local args = {}
	args.action = "Register"
	args.user = user
	args.pass = pass
	args.type = rtype
	args.userip = oRole.m_ipAddr
	args.location = UserLocationMgr.GetLocation(args.userip) or ""
	args.nick = nick
	args.head = head
	args.token = GenToken()
	args.tokenTime = currTime
	args.expire_time = currTime + _G["ServCfg"]["register_vip_gift"]
	data = TextCode.JsonDecode(ReqEx.ReqDBS(args, nil))
    if data.code == RetCode.Success[1] then
    	if rtype == RoleDef.UserType.User or rtype == RoleDef.UserType.Guest then
    		-- 如果是个人账户或者游客
	    	-- 重新初始化角色
		    local headers = ngx.req.get_headers()
		    local appP = headers["appP"] or "Other"
		    local cVersion = headers["appV"] or "0.0.0"
		    local sVersion = _G["ServCfg"]["Version"]["MaxVersion"] or "0.0.0"
		    data = oRole:Init(data.result.uid, data.result.token, 
		    	oRole.m_cVersion, oRole.m_sVersion, oRole.m_platID, oRole.m_action, oRole.m_operator)
		    -- 注册成功后，需要发一封欢迎邮件
		    local tRegMail = MailCfg.MailList[1]
		    MailMgr.AddSysNotice("", data.result.uid, tRegMail.title, tRegMail.summary, tRegMail.content, tRegMail.attachment)
			-- 注册Log
			oRole:LogAccount(LogDef.EventType.Register)
		else
			assert(false, "InnerRegister: type error!")
		end
    end
	return data
end

-- 游客账号验证（自动注册）
function GuestVerify(oRole, user, pass, nick)
	assert(oRole:IsClass(CRole), "oRole is not validate !")

    pass = DecodePwd(pass or TextCode.Base64Encode("000000"))
	local args = {}
	args.action = "Verify"
	args.user = user
	args.pass = pass
	args.currTime = os.time()
	args.expiredTime = TokenExpireTime
	args.token = GenToken()
	local data = TextCode.JsonDecode(ReqEx.ReqDBS(args, nil))
    if data.code == RetCode.NoAccount[1] then
    	-- 若没有账号，便注册一个
    	data = InnerRegister (oRole, RoleDef.UserType.Guest, user, pass, nick)
    end
    return data
end

-- 个人账号注册
function Register (oRole, user, pass, nick, idtc)
	assert(oRole:IsClass(CRole), "oRole is not validate !")

	-- 检查 短信验证码
	local currTime = os.time()
	local data = CheckIdtc(oRole, user, idtc, currTime, ExpiredTime)
    if data.code ~= RetCode.Success[1] then
    	return data
    end
    -- 注册
    pass = DecodePwd(pass)
    if type(nick) ~= 'string' or #nick <= 0 then
    	nick = user
    end
    data = InnerRegister (oRole, RoleDef.UserType.User, user, pass, nick)
    if data.code == RetCode.Success[1] then
    	-- 成功后，要将短信验证码的标志设置为：已使用
    	UseIdtc(oRole, user, idtc, currTime, ExpiredTime)
    end
    return data
end

-- 账号验证
function Verify (oRole, user, pass)
	assert(oRole:IsClass(CRole), "oRole is not validate !")

    pass = DecodePwd(pass)
	local args = {}
	args.action = "Verify"
	args.user = user
	args.pass = pass
	args.currTime = os.time()
	args.expiredTime = TokenExpireTime
	args.token = GenToken()

	local data = TextCode.JsonDecode(ReqEx.ReqDBS(args, nil))
    if data.code == RetCode.Success[1] then
	    -- 重新初始化角色
	    local headers = ngx.req.get_headers()
	    local appP = headers["appP"] or "Other"
	    local cVersion = headers["appV"] or "0.0.0"
	    local sVersion = _G["ServCfg"]["Version"]["MaxVersion"] or "0.0.0"
	    data = oRole:Init(data.result.uid, data.result.token, cVersion, sVersion, oRole:FindPlatID(appP), "Verify")
    end

	return data
end

-- 登陆(获取用户数据)
function Login (oRole)
	assert(oRole:IsClass(CRole) and oRole.m_Init, "oRole is not validate !")
	local uid, token = oRole.m_uid, oRole.m_token

	local args = {}
	args.action = "Login"
	args.uid = uid
	args.token = token
	args.currTime = os.time()
	args.expiredTime = TokenExpireTime
	args.newToken = GenToken()
	local data = TextCode.JsonDecode(ReqEx.ReqDBS(args, nil))
	if data.code == RetCode.Success[1] then
		data.result = oRole:GetDBInfo()
		-- 登录Log
		oRole:LogAccount(LogDef.EventType.Login)
	end

	return data
end

-- 心跳
function Heartbeat(oRole)
	assert(oRole:IsClass(CRole) and oRole.m_Init, "oRole is not validate !")
	local uid, token = oRole.m_uid, oRole.m_token

	local args = {}
	args.action = "AccountQueryID"
	args.uid = uid
	args.token = token
	local data = TextCode.JsonDecode(ReqEx.ReqDBS(args, nil))
	if data.code == RetCode.Success[1] then
		data.result = oRole:GetDBInfo()
	end

	return data
end

-- 丢失了密码
function LosePassWord (oRole, user, pass, idtc)
	assert(oRole:IsClass(CRole), "oRole is not validate !")

	-- 检查 短信验证码
	local currTime = os.time()
	local data = CheckIdtc(oRole, user, idtc, currTime, ExpiredTime)
    if data.code ~= RetCode.Success[1] then
    	return data
    end
    pass = DecodePwd(pass)
    -- 修改密码
	local args = {}
	args.action = "ModifyPass"
	args.user = user
	args.pass = pass
	data = TextCode.JsonDecode(ReqEx.ReqDBS(args, nil))
    if data.code == RetCode.Success[1] then
    	-- 成功后，要将短信验证码的标志设置为：已使用
    	UseIdtc(oRole, user, idtc, currTime, ExpiredTime)
    end
	return data
end

-- 改密码
function ModifyPassWord (oRole, user, pass)
	assert(oRole:IsClass(CRole), "oRole is not validate !")

    pass = DecodePwd(pass)
	local args = {}
	args.action = "ModifyPass"
	args.user = user
	args.pass = pass
	return ReqEx.ReqDBS(args, nil)
end

-- 获取短信验证码 IdentifyCode
function GetIdtc(oRole, user)
	assert(oRole:IsClass(CRole), "oRole is not validate !")

	local currTime = os.time()
	local idtc = 100000 + (LuaEx.Random() % 899999)
	-- 写入数据库
	local args = {}
	args.action = "SaveIdtc"
	args.phno = user
	args.idtc = idtc
	args.idtcTime = currTime
	--args.extra = TextCode.JsonEncode(data.result)
	args.intervalTime = IntervalTime
	local data = TextCode.JsonDecode(ReqEx.ReqDBS(args, nil))
	if data.code == RetCode.Success[1] then
		-- 发送短信验证码
		local timelimit = math.ceil(ExpiredTime / 60) -- 单位 分钟
		data = SmsMgr.SendIdtc(user, idtc, timelimit)
		if data.code ~= RetCode.Success[1] then
			print(user, idtc, data)
		end
	end

	return data
end

-- 获取手机验证码 IdentifyCode，已经注册过的账号才能获取
function GetIdtcWithRegister(oRole, user)
	local data = Verify(oRole, user, "pass")
	if data.code == RetCode.NoAccount[1] then
		return data
	else
		return GetIdtc(oRole, user)
	end
end

-- 获取手机验证码 IdentifyCode，没有注册过的账号才能获取
function GetIdtcWithUnRegister(oRole, user)
	local data = Verify(oRole, user, "pass")
	if data.code == RetCode.NoAccount[1] then
		return GetIdtc(oRole, user)
	else
		return {code = RetCode.ExistAccount[1], message = RetCode.ExistAccount[2], result = nil}
	end
end

-- 校验短信验证码
function CheckIdtc(oRole, user, idtc, currTime, expiredTime)
	assert(oRole:IsClass(CRole), "oRole is not validate !")

	-- 如果不需要短信验证码，就直接返回成功
    if _G["ServCfg"]["check_idtc"] == 0 then
		return {code = RetCode.Success[1], message = RetCode.Success[2], result = {}}
    end

	currTime = currTime or os.time()
	expiredTime = expiredTime or ExpiredTime
	local args = {}
	args.action = "VerifyIdtc"
	args.phno = user
	args.idtc = idtc
	args.currTime = currTime
	args.expiredTime = expiredTime
	return TextCode.JsonDecode(ReqEx.ReqDBS(args, nil))
end

-- 使用短信验证码
function UseIdtc(oRole, user, idtc, currTime, expiredTime)
	assert(oRole:IsClass(CRole), "oRole is not validate !")

	local args = {}
	args.action = "UseIdtc"
	args.phno = user
	args.idtc = idtc
	args.currTime = currTime
	args.expiredTime = expiredTime
	return TextCode.JsonDecode(ReqEx.ReqDBS(args, nil))
end

-- 登录企业（子）账户
function LoginCom(oRole, com_uid)
	assert(oRole:IsClass(CRole) and oRole.m_Init, "oRole is not validate !")
	local uid, token = oRole.m_uid, oRole.m_token
	local cVersion, sVersion, platID = oRole.m_cVersion, oRole.m_sVersion, oRole.m_platID
	local action, operator = oRole.m_action, oRole.m_operator
	if type(com_uid) ~= 'number' or com_uid <= 0 then
		com_uid = nil
	end

	-- 查询是否有企业子账户（授权）
	-- AccountAuthMgr.QueryAccountAuth(auth_code, auth_type, auth_status, sub_uid, com_uid, auth_uid)
	local data = AccountAuthMgr.QueryAccountAuth(nil, nil, RoleDef.AuthStatus.Normal, nil, com_uid, uid)
	if data.code ~= RetCode.Success[1] then
		return data
	end
	if not data.result[1] then
		-- 并没有 有效的企业账户
		data = {code = RetCode.NotComOrSub[1], message = RetCode.NotComOrSub[2], result = nil}
		return data
	end

    -- 企业子账户需要更新 token
    data = AccountMgr.UpdateToken(nil, data.result[1].sub_uid)
    if data.code ~= RetCode.Success[1] then
        return data
    end
	-- 创建企业子账户角色对象
	local subRole = CRole:new()
	data = subRole:Init(tonumber(data.result.uid), data.result.token, cVersion, sVersion, platID, action, operator)
	if data.code ~= RetCode.Success[1] then
		return data
	end
	-- 登录
	return Login(subRole)
end

-- 获取头像
function GetHeadImg(oRole, md5)
	assert(oRole:IsClass(CRole) and oRole.m_Init, "oRole is not validate !")
	local uid, token = oRole.m_uid, oRole.m_token

	-- DBS
	local data = AccountQueryID(uid, token)
    if data.code ~= RetCode.Success[1] then
        return nil
    end
	-- FLS
	args = {}
	args.action = "GetHeadImg"
	args.uid = uid
	args.name = data.result.head
	args.md5 = md5
	ret = ReqEx.ReqFLS(args, nil)
    --ngx.header["Content-Type"] = nil
    ngx.header["Content-Type"] = "application/octet-stream"
    ngx.header["Content-Length"] = string.len(ret)
	return ret
end

-- 更新头像和昵称
function ModifyHeadAndNick(oRole, nick, headImg)
	assert(oRole:IsClass(CRole), "oRole is not validate !")
	local uid, token, rtype, oldHead = oRole.m_uid, oRole.m_token, oRole.m_type, oRole.m_head

	local data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}
	--[[
	-- 企业账户不能同名
	if rtype == RoleDef.UserType.Com and type(nick) == 'string' and #nick > 0 then
		-- AccountMgr.QueryUser(uid, token, user, pass, rtype, status, owner_uid, nick)
		local data = AccountMgr.QueryUser(nil, nil, nil, nil, RoleDef.UserType.Com, nil, nil, nick)
	    if data.code ~= RetCode.Success[1] then
	        return data
	    end
	    if data.result[1] then
	    	-- 已经存在名字为 name 的企业账户
	    	data = {code = RetCode.SameUserName[1], message = RetCode.SameUserName[2], result = nil}
			return data
	    end
	end
	--]]

    -- 是否更新头像
	local isModHead = (type(headImg) == 'string' and #headImg > 0)
	local head = nil
	if isModHead then
		-- FLS
		local args = {}
		args.action = "AddHeadImg"
		args.uid = uid
		args.token = token
		local ret = ReqEx.ReqFLS(args, headImg, ngx.HTTP_POST)
		data = TextCode.JsonDecode(ret)
		if data.code ~= RetCode.Success[1] then
			return data
		end
		head = data.result
	end

	-- DBS
	local args = {}
	args.action = "ModifyHeadAndNick"
	args.uid = uid
	args.token = token
	args.nick = nick
	args.head = head
	data = TextCode.JsonDecode(ReqEx.ReqDBS(args))
	if data.code == RetCode.Success[1] then
		-- 更新成功，删除老的头像
		if isModHead and oldHead ~= head and #oldHead > 0 then
			local args = {}
			args.action = "DelHeadImg"
			args.uid = uid
			args.token = token
			args.name = oldHead
			local ret = ReqEx.ReqFLS(args, headImg, ngx.HTTP_POST)
		end
	else
		-- 更新失败，删除新的头像
		if isModHead and oldHead ~= head and #head > 0 then
			local args = {}
			args.action = "DelHeadImg"
			args.uid = uid
			args.token = token
			args.name = head
			local ret = ReqEx.ReqFLS(args, headImg, ngx.HTTP_POST)
		end
	end
	return data
end

-- 查询企业
function FindCom(oRole, phno, com_uid, name)
	local owner_uid = nil
	if type(phno) == 'string' and #phno == 11 then
		-- 根据企业主（企业账户管理员）的手机号码，查询企业主uid
		local data = AccountMgr.QueryAccount(phno, nil)
		if data.code ~= RetCode.Success[1] then
			return data
		end
		owner_uid = data.result.uid
	end

	local data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = {}}
	-- 根据企业账户的uid或者企业名字或者企业主（企业账户拥有者）的uid，查询企业信息
	com_uid = tonumber(com_uid) or nil
	if type(name) ~= 'string' or #name == 0 then
		name = nil
	end
	if (not owner_uid) and (not com_uid) and (not name) then
		return data
	end
	-- AccountMgr.QueryUser(uid, token, user, pass, rtype, status, owner_uid, nick)
	data = AccountMgr.QueryUser(com_uid, nil, nil, nil, RoleDef.UserType.Com, RoleDef.UserStatus.Normal, owner_uid, name)
	return data
end
