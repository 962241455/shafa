-- 到GM服务端的协议
_G["C2GMS"] = {}


-------------------------------- GM 管理员相关指令。 --------------------------------
-- 登录GM 
C2GMS.GMLogin = function (oGM, oRole, args, body, bodyFile)
    assert(oGM:IsClass(CGMRole), "oGM is not validate !")
    --assert(oRole:IsClass(CRole), "oRole is not validate !")

    local data = oGM:UpdateToken()
    if data.code == RetCode.Success[1] then
        local gmData = oGM:GMGetData()
        data = {code = RetCode.Success[1], message = RetCode.Success[2], result = gmData}
    end
    return data
end

-- 修改GM密码 
C2GMS.GMModPwd = function (oGM, oRole, args, body, bodyFile)
    assert(oGM:IsClass(CGMRole), "oGM is not validate !")
    --assert(oRole:IsClass(CRole), "oRole is not validate !")
    local data = oGM:GMModPwd(tostring(args.pass or ""))
    return data
end

-- 获取GM 账号信息、GMList
C2GMS.GMGetData = function (oGM, oRole, args, body, bodyFile)
    assert(oGM:IsClass(CGMRole), "oGM is not validate !")
    --assert(oRole:IsClass(CRole), "oRole is not validate !")

    local gmData = oGM:GMGetData()
    local data = {code = RetCode.Success[1], message = RetCode.Success[2], result = gmData}
    return data
end

-- 获取某条GM指令的详细信息，包括参数、权限、子命令
C2GMS.GMGetCmdInfo = function (oGM, oRole, args, body, bodyFile)
    assert(oGM:IsClass(CGMRole), "oGM is not validate !")
    --assert(oRole:IsClass(CRole), "oRole is not validate !")
    local data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}
    local info = oGM:GMGetCmdInfo(args.cmd)
    if info then
        data = {code = RetCode.Success[1], message = RetCode.Success[2], result = info}
    end
    return data
end


-- 获取所有GM账号
C2GMS.AllGM = function (oGM, oRole, args, body, bodyFile)
    assert(oGM:IsClass(CGMRole), "oGM is not validate !")
    --assert(oRole:IsClass(CRole), "oRole is not validate !")
    local data = oGM:AllGM()
    return data
end

-- 增加一个GM账号
C2GMS.AddGM = function (oGM, oRole, args, body, bodyFile)
    assert(oGM:IsClass(CGMRole), "oGM is not validate !")
    --assert(oRole:IsClass(CRole), "oRole is not validate !")
    local data = oGM:AddGM(args.name, tostring(args.pass or ""), tonumber(args.power))
    return data
end

-- 删除一个GM账号
C2GMS.DelGM = function (oGM, oRole, args, body, bodyFile)
    assert(oGM:IsClass(CGMRole), "oGM is not validate !")
    --assert(oRole:IsClass(CRole), "oRole is not validate !")
    local data = oGM:DelGM(args.name)
    return data
end

-- 增加一个GM账号
C2GMS.ModGM = function (oGM, oRole, args, body, bodyFile)
    assert(oGM:IsClass(CGMRole), "oGM is not validate !")
    --assert(oRole:IsClass(CRole), "oRole is not validate !")
    local data = oGM:ModGM(args.name, tostring(args.pass or ""), tonumber(args.power))
    return data
end



-------------------------------- 操作系统数据的 GM 相关指令。 --------------------------------
-- 开启或者关闭 会员限制功能
C2GMS.SetVipLimit = function (oGM, oRole, args, body, bodyFile)
    assert(oGM:IsClass(CGMRole), "oGM is not validate !")

    _G["ServCfg"]["vip_limit"] = tonumber(args.on)
    local data = {code = RetCode.Success[1], message = RetCode.Success[2], result = _G["ServCfg"]["vip_limit"]}
    return data
end

-- 开启或者关闭 充值功能
C2GMS.SetOpenPay = function (oGM, oRole, args, body, bodyFile)
    assert(oGM:IsClass(CGMRole), "oGM is not validate !")

    _G["ServCfg"]["open_pay"] = tonumber(args.on)
    local data = {code = RetCode.Success[1], message = RetCode.Success[2], result = _G["ServCfg"]["open_pay"]}
    return data
end

-- 系统通知、系统邮件之类的
C2GMS.AddSysNotice = function (oGM, oRole, args, body, bodyFile)
    assert(oGM:IsClass(CGMRole), "oGM is not validate !")
    local gmName = oGM.name
    local recv_uid, expire_time = tonumber(args.recv_uid), tonumber(args.expire_time)
    local title, summary, content, attachment = args.title, args.summary, args.content, args.attachment
    return MailMgr.AddSysNotice(gmName, recv_uid, title, summary, content, attachment, expire_time)
end



-------------------------------- 用户相关指令。 --------------------------------
-- 查询用户数据
C2GMS.QueryAllUser = function (oGM, oRole, args, body, bodyFile)
    assert(oGM:IsClass(CGMRole), "oGM is not validate !")
    --assert(oRole:IsClass(CRole), "oRole is not validate !")

    local uid, status, rtype = tonumber(args.uid), tonumber(args.status), tonumber(args.type)
    local user, nick, owner_uid = args.user, args.nick, tonumber(args.owner_uid)
    local token, pass = nil, nil
    local data = AccountMgr.QueryUser(uid, token, user, pass, rtype, status, owner_uid, nick)
    return data
end

-- 查询授权
C2GMS.QueryAccountAuth = function (oGM, oRole, args, body, bodyFile)
    assert(oGM:IsClass(CGMRole), "oGM is not validate !")
    --assert(oRole:IsClass(CRole), "oRole is not validate !")

    local auth_code, auth_type, auth_status = args.auth_code, tonumber(args.auth_type), tonumber(args.auth_status)
    local sub_uid, com_uid, auth_uid = tonumber(args.sub_uid), tonumber(args.com_uid), tonumber(args.auth_uid)
    local data = AccountAuthMgr.QueryAccountAuth(auth_code, auth_type, auth_status, sub_uid, com_uid, auth_uid)
    return data
end

-- 修改用户密码
C2GMS.ModifyPass = function (oGM, oRole, args, body, bodyFile)
    assert(oGM:IsClass(CGMRole), "oGM is not validate !")
    assert(oRole:IsClass(CRole), "oRole is not validate !")

    local tInfo = oRole:GetDBInfo()
    local pass = TextCode.Base64Encode(args.pass)
    local data = AccountMgr.ModifyPassWord (oRole, tInfo.user, pass)
    return data
end

-- 个人账户（企业主）将自己的面料、沙发数据转移到企业账户中。
C2GMS.UserDataToComData = function (oGM, oRole, args, body, bodyFile)
    assert(oGM:IsClass(CGMRole), "oGM is not validate !")
    assert(oRole:IsClass(CRole), "oRole is not validate !")

    local com_uid = tonumber(args.com_uid)
    return AccountAuthMgr.UserDataToComData(oRole, com_uid)
end

-- 个人账户（企业主）将企业的面料、沙发数据转移到个人账户中。
C2GMS.ComDataToUserData = function (oGM, oRole, args, body, bodyFile)
    assert(oGM:IsClass(CGMRole), "oGM is not validate !")
    assert(oRole:IsClass(CRole), "oRole is not validate !")

    local uid, token = oRole.m_uid, oRole.m_token
    local cVersion, sVersion, platID = oRole.m_cVersion, oRole.m_sVersion, oRole.m_platID
    local action, operator = oRole.m_action, oRole.m_operator

    -- 查询管理员授权
    -- AccountAuthMgr.QueryAccountAuth(auth_code, auth_type, auth_status, sub_uid, com_uid, auth_uid)
    local data = AccountAuthMgr.QueryAccountAuth(nil, RoleDef.AuthType.Owner, RoleDef.AuthStatus.Normal, nil, nil, uid)
    if data.code ~= RetCode.Success[1] then
        return data
    end
    if not data.result[1] then
        -- 并没有 有效的企业账户
        data = {code = RetCode.NotComOrSub[1], message = RetCode.NotComOrSub[2], result = nil}
        return data
    end
    -- 创建企业子账户角色对象
    data = AccountMgr.QueryAccount(nil, data.result[1].sub_uid)
    if data.code ~= RetCode.Success[1] then
        return data
    end
    local subRole = CRole:new()
    data = subRole:Init(tonumber(data.result.uid), data.result.token, cVersion, sVersion, platID, action, operator)
    if data.code ~= RetCode.Success[1] then
        return data
    end
    
    return AccountAuthMgr.ComDataToUserData(subRole)
end



-------------------------------- LogTool 相关指令操作。 --------------------------------

-- 测试所有参数类型
C2GMS.Test = function (oGM, oRole, args, body, bodyFile)
    assert(oGM:IsClass(CGMRole), "oGM is not validate !")

    local data = {code = RetCode.Success[1], message = RetCode.Success[2], result = ""}
    return data
end
