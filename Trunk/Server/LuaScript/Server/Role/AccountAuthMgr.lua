-- AccountAuthMgr 企业账户&授权相关
module("AccountAuthMgr", package.seeall)

-- 生成授权码。md5(com_uid, auth_uid, grant_time)。
function GenAuthCode(com_uid, auth_uid, grant_time)
	assert(com_uid and auth_uid and grant_time, "GenAuthCode Error!")
	return TextCode.Md5Encode(com_uid .. auth_uid .. grant_time)
end

-- 生成企业用户名。
function GenUserName(prefix)
	local timestmp = os.date("%Y%m%d%H%M%S")
	local rand = 100 + (LuaEx.Random() % 899)
	return prefix .. timestmp .. rand
end

-- 查询授权
function QueryAccountAuth(auth_code, auth_type, auth_status, sub_uid, com_uid, auth_uid)
	-- 查询
	local args = {}
	args.action = "QueryAccountAuth"
	args.auth_code = auth_code -- 唯一ID，授权码。
	args.auth_type = auth_type -- 授权码类型。0：企业子账号--职员账户。1：企业子账号--老板账户。
	args.auth_status = auth_status -- 授权码状态。0：授权中。1：生效状态。2：失效状态。
	args.sub_uid = sub_uid -- 被授权的账户，企业子账户uid(虚拟账户)。
	args.com_uid = com_uid -- 授权主体账户，企业账户uid。
	args.auth_uid = auth_uid -- 被授权的账户，个人账户uid。
	--args.grant_time = grant_time -- 授权开始时间。企业账户发起授权的时间。
	--args.finish_time = finish_time -- 授权完成时间。个人账户接受授权的时间。
	local data = TextCode.JsonDecode(ReqEx.ReqDBS(args, nil))
	return data
end

-- 该企业子账户 是否是 企业账户拥有者(企业账户管理员的企业子账户)。
function IsComOwner(oRole, bCheckPassWord, pass)
	assert(oRole:IsClass(CRole) and oRole.m_Init, "oRole is not validate !")
	local uid, token, rtype = oRole.m_uid, oRole.m_token, oRole.m_type

	local data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}
	if rtype ~= RoleDef.UserType.Com then
		-- 企业账户才能进行此操作
		data = {code = RetCode.NotComType[1], message = RetCode.NotComType[2], result = nil}
		return data
	end
	local auth_type, auth_status = oRole.m_tAuthInfo.auth_type, oRole.m_tAuthInfo.auth_status
	if auth_status ~= RoleDef.AuthStatus.Normal then
		-- 授权未生效
		data = {code = RetCode.UnvalidAuth[1], message = RetCode.UnvalidAuth[2], result = nil}
		return data
	end
	if auth_type ~= RoleDef.AuthType.Owner then
		-- 并不是企业账户拥有者，拥有boss级别的授权才能进行此操作
		data = {code = RetCode.NotComOwner[1], message = RetCode.NotComOwner[2], result = nil}
		return data
	end
	-- 是否需要验证企业管理员的账户密码
	if bCheckPassWord == true then
		local auth_type, auth_status = oRole.m_tAuthInfo.auth_type, oRole.m_tAuthInfo.auth_status
		local auth_uid = oRole.m_tAuthInfo.auth_uid
		data = AccountMgr.QueryAccount(nil, auth_uid)
		if data.code ~= RetCode.Success[1] then
			return data
		end
		local password = data.result.pass
		local auth_pass = AccountMgr.DecodePwd(pass)
		if auth_pass ~= password then
			-- 密码错误
			data = {code = RetCode.PassWordErr[1], message = RetCode.PassWordErr[2], result = nil}
			return data
		end
	end
	
	data = {code = RetCode.Success[1], message = RetCode.Success[2], result = nil}
	return data
end

-- 是否不是是其他企业账户的成员。一个个人账户只能隶属于一个有效的企业账户。
function WithoutSubAccount(uid)
	local data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}
	-- QueryAccountAuth(auth_code, auth_type, auth_status, sub_uid, com_uid, auth_uid)
	data = QueryAccountAuth(nil, nil, RoleDef.AuthStatus.Normal, nil, nil, uid)
    if data.code ~= RetCode.Success[1] then
        return data
    end
    if data.result[1] then
    	-- 已经是其他企业账户的成员。一个个人账户只能隶属于一个有效的企业账户。
    	data = {code = RetCode.HasComOrSub[1], message = RetCode.HasComOrSub[2], result = nil}
		return data
    end
	data = {code = RetCode.Success[1], message = RetCode.Success[2], result = nil}
    return data
end

-- 个人账户创建企业账户
function CreateComAccount(oRole, name, logo)
	assert(oRole:IsClass(CRole) and oRole.m_Init, "oRole is not validate !")
	local uid, token, user, rtype = oRole.m_uid, oRole.m_token, oRole.m_user, oRole.m_type
	local cVersion, sVersion, platID = oRole.m_cVersion, oRole.m_sVersion, oRole.m_platID
	local action, operator = oRole.m_action, oRole.m_operator

	local data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}
	if rtype ~= RoleDef.UserType.User then
		data = {code = RetCode.NotUserType[1], message = RetCode.NotUserType[2], result = nil}
		return data
	end
	if type(name) ~= 'string' or #name <= 0 then
		data = {code = RetCode.NotComName[1], message = RetCode.NotComName[2], result = nil}
		return data
	end

	--[[
	-- 不能同名
	-- AccountMgr.QueryUser(uid, token, user, pass, rtype, status, owner_uid, nick)
	data = AccountMgr.QueryUser(nil, nil, nil, nil, RoleDef.UserType.Com, nil, nil, name)
    if data.code ~= RetCode.Success[1] then
        return data
    end
    if data.result[1] then
    	-- 已经存在名字为 name 的企业账户
    	data = {code = RetCode.SameUserName[1], message = RetCode.SameUserName[2], result = nil}
		return data
    end
    --]]
	-- 一个个人账号只能拥有一个有效的企业账户
	data = WithoutSubAccount(uid)
    if data.code ~= RetCode.Success[1] then
        return data
    end

    -- 是否是第一次创建企业账户
    local isFirst = true
    if tonumber(oRole.m_tInfo.com_cnt) > 0 then
    	isFirst = false
    end

	-- 生成必要参数
	local sub_user = GenUserName(user)
	local com_user = GenUserName(user)
	while (sub_user == com_user) do
		sub_user = GenUserName(user)
		com_user = GenUserName(user)
	end
	local currTime = os.time()
	local com_nick, com_head = name, ""
	local grant_time, finish_time = currTime, currTime
	local auth_code = GenAuthCode(com_user, sub_user, grant_time)
	local com_expire_time = 0
	if isFirst then
		-- 第一次创建企业账户，赠送企业会员时间
		com_expire_time = currTime + _G["ServCfg"]["createcom_vip_gift"]
	end
	-- 创建
	local args = {}
	args.action = "CreateComAccount"
	args.uid = uid
	args.token = token
	args.sub_user = sub_user
	args.com_user = com_user
	args.com_nick = com_nick
	args.com_head = com_head
	args.com_expire_time = com_expire_time
	args.auth_code = auth_code
	args.grant_time = grant_time
	args.finish_time = finish_time
	local data = TextCode.JsonDecode(ReqEx.ReqDBS(args, nil))

	-- 更新 公司 logo
	if data.code == RetCode.Success[1] then
		-- 成功后，记录log
	    oRole:LogNormal(LogDef.EventType.UserCreateCom, TextCode.JsonEncode({name = name}))
	    -- 更新 公司 logo
		if type(logo) == 'string' and #logo > 0 then
			-- 生成企业子账户角色对象，老板权限
			local subRole = CRole:new()
			local subData = subRole:Init(tonumber(data.result.sub_uid), token, cVersion, sVersion, platID, action, operator)
			-- 更新 公司 logo
			subData = AccountMgr.ModifyHeadAndNick(subRole, nil, logo)
		end
	end

	return data
end

-- 个人账户拒绝授权，只针对 企业成员(auth_type=0)。
function RefuseAccountAuth(oRole, auth_code)
	assert(oRole:IsClass(CRole) and oRole.m_Init, "oRole is not validate !")
	local uid, token, user, rtype = oRole.m_uid, oRole.m_token, oRole.m_user, oRole.m_type

	local data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}
	if rtype ~= RoleDef.UserType.User then
		data = {code = RetCode.NotUserType[1], message = RetCode.NotUserType[2], result = nil}
		return data
	end

	local args = {}
	args.action = "RefuseAccountAuth"
	args.uid = uid
	args.token = token
	args.auth_code = auth_code
	local data = TextCode.JsonDecode(ReqEx.ReqDBS(args, nil))
	if data.code == RetCode.Success[1] then
		-- 成功后，记录log
	    oRole:LogNormal(LogDef.EventType.UserRefuseAuth, TextCode.JsonEncode({auth_code = auth_code}))
	end
	return data
end

-- 个人账户接受授权，只针对 企业成员(auth_type=0)。
function AcceptAccountAuth(oRole, auth_code)
	assert(oRole:IsClass(CRole) and oRole.m_Init, "oRole is not validate !")
	local uid, token, user, rtype = oRole.m_uid, oRole.m_token, oRole.m_user, oRole.m_type

	local data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}
	if rtype ~= RoleDef.UserType.User then
		data = {code = RetCode.NotUserType[1], message = RetCode.NotUserType[2], result = nil}
		return data
	end
	-- 如果已经有企业了，则不能接受新的邀请。
	-- 一个个人账号只能拥有一个有效的企业账户
	data = WithoutSubAccount(uid)
    if data.code ~= RetCode.Success[1] then
        return data
    end

	local sub_user = GenUserName(user)
	local finish_time = os.time()
	local args = {}
	args.action = "AcceptAccountAuth"
	args.uid = uid
	args.token = token
	args.auth_code = auth_code
	args.sub_user = sub_user
	args.finish_time = finish_time
	local data = TextCode.JsonDecode(ReqEx.ReqDBS(args, nil))
	if data.code == RetCode.Success[1] then
		-- 成功后，记录log
	    oRole:LogNormal(LogDef.EventType.UserAcceptAuth, TextCode.JsonEncode({auth_code = auth_code}))
	end
	return data
end

-- 个人账户获取所有有效授权信息
function GetMyAccountAuth(oRole)
	assert(oRole:IsClass(CRole) and oRole.m_Init, "oRole is not validate !")
	local uid, token, user, rtype = oRole.m_uid, oRole.m_token, oRole.m_user, oRole.m_type

	local data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}
	if rtype ~= RoleDef.UserType.User then
		data = {code = RetCode.NotUserType[1], message = RetCode.NotUserType[2], result = nil}
		return data
	end

	-- QueryAccountAuth(auth_code, auth_type, auth_status, sub_uid, com_uid, auth_uid)
	return QueryAccountAuth(nil, nil, RoleDef.AuthStatus.Normal, nil, nil, uid)
end

-- 企业账户获取所有成员信息
function GetAllAccountAuth(oRole)
	assert(oRole:IsClass(CRole) and oRole.m_Init, "oRole is not validate !")
	local uid, token, rtype = oRole.m_uid, oRole.m_token, oRole.m_type

	-- 是否是企业账户拥有者(企业管理员账号)
	local data = IsComOwner(oRole)
    if data.code ~= RetCode.Success[1] then
        return data
    end

	local args = {}
	args.action = "GetAllAccountAuth"
	args.uid = uid
	args.token = token
	local data = TextCode.JsonDecode(ReqEx.ReqDBS(args, nil))
	return data
end

-- 企业账户增加一个成员授权邀请，只针对 企业成员(auth_type=0)。
function AddAccountAuth(oRole, auth_uid)
	assert(oRole:IsClass(CRole) and oRole.m_Init, "oRole is not validate !")
	local uid, token, rtype = oRole.m_uid, oRole.m_token, oRole.m_type

	-- 是否是企业账户拥有者(企业管理员账号)
	local data = IsComOwner(oRole)
    if data.code ~= RetCode.Success[1] then
        return data
    end

	-- 如果被邀请者已经拥有企业，则不能被邀请。
	-- 一个个人账号只能拥有一个有效的企业账户
	data = WithoutSubAccount(auth_uid)
    if data.code ~= RetCode.Success[1] then
        return data
    end

	local grant_time, finish_time = os.time(), 0
	local auth_code = GenAuthCode(uid, auth_uid, grant_time)
	local args = {}
	args.action = "AddAccountAuth"
	args.uid = uid
	args.token = token
	args.auth_uid = auth_uid
	args.auth_code = auth_code
	args.grant_time = grant_time
	args.finish_time = finish_time

	local data = TextCode.JsonDecode(ReqEx.ReqDBS(args, nil))
	if data.code == RetCode.Success[1] then
		-- 成功后，记录log
	    oRole:LogNormal(LogDef.EventType.ComAddAuth, TextCode.JsonEncode({auth_uid = auth_uid}))
	end
	return data
end

-- 企业账户增加一个成员授权邀请，只针对 企业成员(auth_type=0)。
function AddAccountAuthByUser(oRole, auth_user)
	assert(oRole:IsClass(CRole) and oRole.m_Init, "oRole is not validate !")
	--local uid, token, rtype = oRole.m_uid, oRole.m_token, oRole.m_type
	local data = AccountMgr.QueryAccount(auth_user, nil)
    if data.code ~= RetCode.Success[1] then
        return data
    end
    local auth_uid = data.result.uid
	return AddAccountAuth(oRole, auth_uid)
end

-- 企业账户删除一个成员授权，只针对 企业成员(auth_type=0)。
function DelAccountAuth(oRole, auth_uid)
	assert(oRole:IsClass(CRole) and oRole.m_Init, "oRole is not validate !")
	local uid, token, rtype = oRole.m_uid, oRole.m_token, oRole.m_type

	local data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}
	if rtype ~= RoleDef.UserType.Com then
		-- 企业账户才能进行此操作
		data = {code = RetCode.NotComType[1], message = RetCode.NotComType[2], result = nil}
		return data
	end
	local auth_type, auth_status = oRole.m_tAuthInfo.auth_type, oRole.m_tAuthInfo.auth_status
	local my_auth_uid = oRole.m_tAuthInfo.auth_uid
	if auth_status ~= RoleDef.AuthStatus.Normal then
		-- 授权未生效
		data = {code = RetCode.UnvalidAuth[1], message = RetCode.UnvalidAuth[2], result = nil}
		return data
	end
	-- 删除自己或者删除成员
	if auth_uid == my_auth_uid then
		-- 如果删除自己，则自己不能是企业账户拥有者
		if auth_type == RoleDef.AuthType.Owner then
			data = {code = RetCode.NotDelOwner[1], message = RetCode.NotDelOwner[2], result = nil}
			return data
		end
	else
		-- 如果删除成员，则自己必须是企业账户拥有者
		if auth_type ~= RoleDef.AuthType.Owner then
			data = {code = RetCode.NotComOwner[1], message = RetCode.NotComOwner[2], result = nil}
			return data
		end
	end

	local args = {}
	args.action = "DelAccountAuth"
	args.uid = uid
	args.token = token
	args.auth_uid = auth_uid
	local data = TextCode.JsonDecode(ReqEx.ReqDBS(args, nil))
	if data.code == RetCode.Success[1] then
		-- 成功后，记录log
	    oRole:LogNormal(LogDef.EventType.ComDelAuth, TextCode.JsonEncode({auth_uid = auth_uid}))
	end
	return data
end

-- 企业子账户主动解除授权
function QuitAccountAuth(oRole)
	assert(oRole:IsClass(CRole) and oRole.m_Init, "oRole is not validate !")
	return DelAccountAuth(oRole, oRole.m_tAuthInfo.auth_uid)
end

-- 企业账户转让，老板权限的转移
function TransferAccountAuth(oRole, pass, auth_uid)
	assert(oRole:IsClass(CRole) and oRole.m_Init, "oRole is not validate !")
	local uid, token, rtype = oRole.m_uid, oRole.m_token, oRole.m_type

	-- 是否是企业账户拥有者(企业管理员账号)
	local data = IsComOwner(oRole, true, pass)
    if data.code ~= RetCode.Success[1] then
        return data
    end
	local auth_type, auth_status = oRole.m_tAuthInfo.auth_type, oRole.m_tAuthInfo.auth_status
	local my_auth_uid = oRole.m_tAuthInfo.auth_uid
	-- 不能将自己的企业账户转让给自己
	if my_auth_uid == auth_uid then
		data = {code = RetCode.NotMeToMe[1], message = RetCode.NotMeToMe[2], result = nil}
		return data
	end
	-- 新老板必须是相同企业的成员
	-- AccountAuthMgr.QueryAccountAuth(auth_code, auth_type, auth_status, sub_uid, com_uid, auth_uid)
	data = AccountAuthMgr.QueryAccountAuth(nil, nil, RoleDef.AuthStatus.Normal, nil, uid, auth_uid)
	if data.code ~= RetCode.Success[1] then
		return data
	end
	if not data.result[1] then
		-- 新老板不是该企业的成员
		data = {code = RetCode.NotComMember[1], message = RetCode.NotComMember[2], result = nil}
		return data
	end

	local args = {}
	args.action = "TransferAccountAuth"
	args.uid = uid
	args.token = token
	args.auth_uid = auth_uid
	local data = TextCode.JsonDecode(ReqEx.ReqDBS(args, nil))
	if data.code == RetCode.Success[1] then
		-- 成功后，记录log
	    oRole:LogNormal(LogDef.EventType.ComTransfer, TextCode.JsonEncode({auth_uid = auth_uid}))
	end
	return data
end

-- 企业账户解散授权(Dismiss)。
function DismissAccountAuth(oRole, pass)
	assert(oRole:IsClass(CRole) and oRole.m_Init, "oRole is not validate !")
	local uid, token, rtype = oRole.m_uid, oRole.m_token, oRole.m_type

	-- 是否是企业账户拥有者(企业管理员账号)
	local data = IsComOwner(oRole, true, pass)
    if data.code ~= RetCode.Success[1] then
        return data
    end

	local args = {}
	args.action = "DismissAccountAuth"
	args.uid = uid
	args.token = token
	local data = TextCode.JsonDecode(ReqEx.ReqDBS(args, nil))
	if data.code == RetCode.Success[1] then
		-- 成功后，记录log
	    oRole:LogNormal(LogDef.EventType.ComDismiss)
	end
	return data
end



-- 企业账户拒绝授权申请，只针对 企业成员(auth_type=0)。
function RefuseAccountApply(oRole, auth_code)
	assert(oRole:IsClass(CRole) and oRole.m_Init, "oRole is not validate !")
	local uid, token, rtype = oRole.m_uid, oRole.m_token, oRole.m_type

	-- 是否是企业账户拥有者(企业管理员账号)
	local data = IsComOwner(oRole)
    if data.code ~= RetCode.Success[1] then
        return data
    end

	local args = {}
	args.action = "RefuseAccountApply"
	args.uid = uid
	args.token = token
	args.auth_code = auth_code

	local data = TextCode.JsonDecode(ReqEx.ReqDBS(args, nil))
	if data.code == RetCode.Success[1] then
		-- 成功后，记录log
	    oRole:LogNormal(LogDef.EventType.ComRefuseApply, TextCode.JsonEncode({auth_code = auth_code}))
	end
	return data
end

-- 企业账户接受授权申请，只针对 企业成员(auth_type=0)。
function AcceptAccountApply(oRole, auth_code)
	assert(oRole:IsClass(CRole) and oRole.m_Init, "oRole is not validate !")
	local uid, token, rtype = oRole.m_uid, oRole.m_token, oRole.m_type

	-- 是否是企业账户拥有者(企业管理员账号)
	local data = IsComOwner(oRole)
    if data.code ~= RetCode.Success[1] then
        return data
    end

	-- 先查询
	-- data = QueryAccountAuth(auth_code, auth_type, auth_status, sub_uid, com_uid, auth_uid)
	data = QueryAccountAuth(auth_code, nil, RoleDef.AuthStatus.Apply, nil, nil, nil)
	if data.code ~= RetCode.Success[1] then
		return data
	end
	if not data.result[1] then
		-- 不存在的授权
		data = {code = RetCode.NotExistAuth[1], message = RetCode.NotExistAuth[2], result = nil}
		return data
	end
	local auth_uid = data.result[1].auth_uid
	data = AccountMgr.QueryAccount(nil, auth_uid)
	if data.code ~= RetCode.Success[1] then
		return data
	end
	local auth_user = data.result.user

	-- 如果申请者已经拥有企业，则不能进行此操作。
	-- 一个个人账号只能拥有一个有效的企业账户
	data = WithoutSubAccount(auth_uid)
    if data.code ~= RetCode.Success[1] then
        return data
    end

	local sub_user = GenUserName(auth_user)
	local finish_time = os.time()
	local args = {}
	args.action = "AcceptAccountApply"
	args.uid = uid
	args.token = token
	args.auth_code = auth_code
	args.sub_user = sub_user
	args.finish_time = finish_time
	local data = TextCode.JsonDecode(ReqEx.ReqDBS(args, nil))
	if data.code == RetCode.Success[1] then
		-- 成功后，记录log
	    oRole:LogNormal(LogDef.EventType.ComAcceptApply, TextCode.JsonEncode({auth_code = auth_code}))
	end
	return data
end

-- 个人账户申请授权，只针对 企业成员(auth_type=0)。
function AddAccountApply(oRole, com_uid)
	assert(oRole:IsClass(CRole) and oRole.m_Init, "oRole is not validate !")
	local uid, token, user, rtype = oRole.m_uid, oRole.m_token, oRole.m_user, oRole.m_type

	local data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}
	if rtype ~= RoleDef.UserType.User then
		data = {code = RetCode.NotUserType[1], message = RetCode.NotUserType[2], result = nil}
		return data
	end

	-- 重复申请，也视为成功
	-- data = QueryAccountAuth(auth_code, auth_type, auth_status, sub_uid, com_uid, auth_uid)
	data = QueryAccountAuth(nil, nil, RoleDef.AuthStatus.Apply, nil, com_uid, uid)
	if data.code ~= RetCode.Success[1] then
		return data
	end
	if data.result[1] then
		data = {code = RetCode.Success[1], message = RetCode.Success[2], result = data.result[1]}
		return data
	end

	-- 如果已经有企业了，则不能申请新的授权
	-- 一个个人账号只能拥有一个有效的企业账户
	data = WithoutSubAccount(uid)
    if data.code ~= RetCode.Success[1] then
        return data
    end

	local grant_time, finish_time = os.time(), 0
	local auth_code = GenAuthCode(com_uid, uid, grant_time)
	local args = {}
	args.action = "AddAccountApply"
	args.uid = uid
	args.token = token
	args.auth_code = auth_code
	args.grant_time = grant_time
	args.finish_time = finish_time
	args.com_uid = com_uid
	local data = TextCode.JsonDecode(ReqEx.ReqDBS(args, nil))
	if data.code == RetCode.Success[1] then
		-- 成功后，记录log
	    oRole:LogNormal(LogDef.EventType.UserAddApply, TextCode.JsonEncode({com_uid = com_uid}))
	end
	return data
end

-- 个人账户（企业主）将自己的面料、沙发数据转移到企业账户中。
function UserDataToComData(oRole, com_uid)
	assert(oRole:IsClass(CRole) and oRole.m_Init, "oRole is not validate !")
	local uid, token, rtype = oRole.m_uid, oRole.m_token, oRole.m_type

	-- 必须是个人账户类型
	local data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}
	if rtype ~= RoleDef.UserType.User then
		data = {code = RetCode.NotUserType[1], message = RetCode.NotUserType[2], result = nil}
		return data
	end

	-- 判断 com_uid
	if type(com_uid) ~= 'number' or com_uid <= 0 then
		com_uid = nil
	end
	-- AccountAuthMgr.QueryAccountAuth(auth_code, auth_type, auth_status, sub_uid, com_uid, auth_uid)
	local data = AccountAuthMgr.QueryAccountAuth(nil, RoleDef.AuthType.Owner, RoleDef.AuthStatus.Normal, nil, com_uid, uid)
	if data.code ~= RetCode.Success[1] then
		return data
	end
	if not data.result[1] then
		-- 并不是企业账户拥有者
		data = {code = RetCode.NotComOwner[1], message = RetCode.NotComOwner[2], result = nil}
		return data
	end
	com_uid = data.result[1].com_uid

    -- 非vip企业账户无法操作
    data = AccountMgr.QueryAccount(nil, com_uid)
	if data.code ~= RetCode.Success[1] then
		return data
	end
    if data.result.expire_time <= os.time() then
    	data = {code = RetCode.NotVip[1], message = RetCode.NotVip[2], result = nil}
    	return data
    end

	-- 转移数据
	local args = {}
	args.action = "UserDataToComData"
	args.uid = uid
	args.token = token
	args.com_uid = com_uid
	local data = TextCode.JsonDecode(ReqEx.ReqDBS(args, nil))
	if data.code == RetCode.Success[1] then
		-- 成功后，记录log
	    oRole:LogNormal(LogDef.EventType.UserDataToComData, TextCode.JsonEncode({com_uid = com_uid}))
	end
	return data
end

-- 企业账户将自己的面料、沙发数据转移到企业主（个人账户）中。
function ComDataToUserData(oRole)
	assert(oRole:IsClass(CRole) and oRole.m_Init, "oRole is not validate !")
	local uid, token, rtype = oRole.m_uid, oRole.m_token, oRole.m_type

	-- 是否是企业账户拥有者(企业管理员账号)
	local data = IsComOwner(oRole)
    if data.code ~= RetCode.Success[1] then
        return data
    end

    -- 非vip企业账户无法操作
    if not oRole:IsVip() then
    	data = {code = RetCode.NotVip[1], message = RetCode.NotVip[2], result = nil}
    end

	-- 转移数据
	local args = {}
	args.action = "ComDataToUserData"
	args.uid = uid
	args.token = token
	local data = TextCode.JsonDecode(ReqEx.ReqDBS(args, nil))
	if data.code == RetCode.Success[1] then
		-- 成功后，记录log
		oRole:LogNormal(LogDef.EventType.ComDataToUserData)
	end
	return data
end
