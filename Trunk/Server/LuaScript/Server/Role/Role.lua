-- 角色类
function CRole:Ctor()
	self.m_Init = false
    self.m_bGM  = false
    self.m_tInfo = nil      -- 直接获取到的账户数据（个人账户、游客账户、企业子账户数据）。
    self.m_tComInfo = nil   -- 如果是企业子账户登录，需要获取授权主体的企业账户数据。
    self.m_tAuthInfo = nil  -- 如果是企业子账户登录，需要获取企业子账户的授权信息。
    -- 账户数据，如果是个人账户，则赋值个人账户数据。如果是企业子账户，则赋值授权主体的企业账户数据。
    self.m_uid = nil
    self.m_token = nil
    self.m_user = nil
    self.m_type = nil
    self.m_status = nil
    self.m_nick = nil
    self.m_head = nil
    self.m_expireTime = nil
    -- 额外数据
    self.m_cVersion = nil
    self.m_sVersion = nil
    self.m_ipAddr   = nil
    self.m_platID   = nil
    self.m_action   = nil
    self.m_operator = nil
end

-- 初始化
function CRole:Init(uid, token, cVersion, sVersion, platID, action, operator)
    -- 是否 GM 操作
    if action == RoleDef.GMAction then
        self.m_bGM = true
    end
    self.m_Init = false
    self.m_tInfo = nil
    self.m_tComInfo = nil
    self.m_tAuthInfo = nil
    -- 账户数据
    self.m_uid = uid
    self.m_token = token
    self.m_user = nil
    self.m_type = nil
    self.m_status = nil
    self.m_nick = nil
    self.m_head = nil
    self.m_expireTime = nil
    -- 额外数据
    self.m_cVersion = cVersion
    self.m_sVersion = sVersion
    self.m_ipAddr   = ngx.var.remote_addr
    self.m_platID   = platID
    self.m_action   = action
    self.m_operator = operator or ""

    -- 通过uid、token查询账号数据
    local data = {code = RetCode.Success[1], message = RetCode.Success[2], result = ""}
    if type(uid) == 'number' and uid > 0 and type(token) == 'string' and #token > 0 then
        data = self:InitDBInfo()
        if data.code ~= RetCode.Success[1] then
            return data
        end
        if self.m_tInfo.type == RoleDef.UserType.Sub then
            self.m_uid = self.m_tComInfo.uid
            self.m_token = self.m_tComInfo.token
            self.m_user = self.m_tComInfo.user
            self.m_type = self.m_tComInfo.type
            self.m_status = self.m_tComInfo.status
            self.m_nick = self.m_tComInfo.nick
            self.m_head = self.m_tComInfo.head
            self.m_expireTime = self.m_tComInfo.expire_time
            if not self.m_bGM then
                self.m_operator = self.m_tInfo.owner_uid
            end
        else
            --self.m_uid = self.m_tInfo.uid
            --self.m_token = self.m_tInfo.token
            self.m_user = self.m_tInfo.user
            self.m_type = self.m_tInfo.type
            self.m_status = self.m_tInfo.status
            self.m_nick = self.m_tInfo.nick
            self.m_head = self.m_tInfo.head
            self.m_expireTime = self.m_tInfo.expire_time
        end
        self.m_Init = true
        -- 是否有会员功能限制(只有会员才能使用某些功能)。1：是；0：否。默认 1
        self.m_tInfo.viplimit = _G["ServCfg"]["vip_limit"]
        -- 是否开放充值功能。1：是；0：否。默认 1
        self.m_tInfo.openpay = _G["ServCfg"]["open_pay"]
        -- 苹果审核服，关闭会员功能限制 以及 关闭充值
        if AccountMgr.IsIosReview() then
            self.m_tInfo.viplimit = 0
            self.m_tInfo.openpay = 0
        end
        -- 同步数据的限制
        self.m_tInfo.tSyncLimit = _G["ServCfg"]["SyncLimit"]
    end
    return data
end

-- 获取数据库中的数据 初始化
function CRole:InitDBInfo()
    -- 通过uid、token查询账号数据
    local uid, token = self.m_uid, self.m_token
    local data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = ""}
    if not (type(uid) == 'number' and uid > 0 and type(token) == 'string' and #token > 0) then
        return data
    end
    data = AccountMgr.AccountQueryID(uid, token)
    if data.code ~= RetCode.Success[1] then
        return data
    end
    -- 原始账号数据
    self.m_tInfo = data.result
    -- 禁止企业账户登录
    assert(data.result.type ~= RoleDef.UserType.Com, "CRole:InitDBInfo Error type = " .. RoleDef.UserType.Com)
    -- 不同账户类型的处理
    if data.result.type == RoleDef.UserType.Guest then
        -- 游客账号，不做任何处理
        data = {code = RetCode.Success[1], message = RetCode.Success[2], result = self.m_tInfo}
    elseif data.result.type == RoleDef.UserType.User then
        -- 如果是个人账户，先判断是否是企业主，若是企业主，则共用企业账户的VIP时间。
        -- AccountAuthMgr.QueryAccountAuth(auth_code, auth_type, auth_status, sub_uid, com_uid, auth_uid)
        data = AccountAuthMgr.QueryAccountAuth(nil, RoleDef.AuthType.Owner, RoleDef.AuthStatus.Normal, nil, nil, uid)
        if data.code == RetCode.Success[1] and data.result[1] then
            local com_uid = data.result[1].com_uid
            data = AccountMgr.QueryAccount(nil, com_uid)
            if data.code == RetCode.Success[1] and data.result.expire_time > self.m_tInfo.expire_time then
                self.m_tInfo.expire_time = data.result.expire_time
            end
        end
        data = {code = RetCode.Success[1], message = RetCode.Success[2], result = self.m_tInfo}
    elseif data.result.type == RoleDef.UserType.Com then
        -- 禁止企业账户登录
        assert(false, "CRole:InitDBInfo Error type = " .. RoleDef.UserType.Com)
    elseif data.result.type == RoleDef.UserType.Sub then
        -- 如果是企业子账户，获取企业子账户授权信息。
        -- AccountAuthMgr.QueryAccountAuth(auth_code, auth_type, auth_status, sub_uid, com_uid, auth_uid)
        data = AccountAuthMgr.QueryAccountAuth(nil, nil, nil, uid, nil, nil)
        if data.code ~= RetCode.Success[1] then
            return data
        end
        if data.result[1].auth_status ~= RoleDef.AuthStatus.Normal then
            -- 授权未生效
            data = {code = RetCode.UnvalidAuth[1], message = RetCode.UnvalidAuth[2], result = nil}
            return data
        end
        if data.result[1].auth_uid ~= self.m_tInfo.owner_uid then
            data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}
            return data
        end
        self.m_tAuthInfo = data.result[1]

        -- 获取授权主体的企业账户数据。
        local com_uid, auth_uid = self.m_tAuthInfo.com_uid, self.m_tAuthInfo.auth_uid
        data = AccountMgr.QueryAccount(nil, self.m_tAuthInfo.com_uid)
        if data.code ~= RetCode.Success[1] then
            return data
        end
        if data.result.type ~= RoleDef.UserType.Com or data.result.status ~= RoleDef.UserStatus.Normal then
            data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}
            return data
        end
        self.m_tComInfo = data.result

        -- 初始化数据完毕
        self.m_tInfo.tAuthInfo = self.m_tAuthInfo
        self.m_tInfo.tComInfo = self.m_tComInfo
        data = {code = RetCode.Success[1], message = RetCode.Success[2], result = self.m_tInfo}
    else
        -- 禁止不支持的类型
        assert(false, "CRole:InitDBInfo Error type = " .. data.result.type)
    end
    --print(data)
    return data
end

-- 获取原始数据库数据
function CRole:GetDBInfo()
    return self.m_tInfo
end

-- 是否会员。
function CRole:IsVip()
    local currTime = os.time()
    if self.m_expireTime > currTime then
        return true
    else
        return false
    end
end

-- 是否受会员限制（非会员被限制，返回true）。
function CRole:IsVipLimit()
    local nViplimit = _G["ServCfg"]["vip_limit"]
    -- 服务器关闭了VIP限制功能，不限制任何用户
    if nViplimit ~= 1 then
        return false
    end
    -- 不限制游客用户
    if self.m_type == RoleDef.UserType.Guest then
        return false
    end
    -- 不限制vip用户
    if self:IsVip() then
        return false
    end

    -- 服务器开启了VIP限制，并且用户非vip会员。
    return true
end

-- 数据同步的限制。
function CRole:GetSyncLimit()
    local tLimit = _G["ServCfg"]["SyncLimit"]["AllLimit"]
    local bVipLimit = self:IsVipLimit()
    -- 不同的账号类型有不同的限制条件
    if self.m_type == RoleDef.UserType.Guest then
        -- 游客账号的限制
        tLimit = _G["ServCfg"]["SyncLimit"]["Guest"]
    elseif self.m_type == RoleDef.UserType.User then
        -- 个人账户
        if bVipLimit then
            tLimit = _G["ServCfg"]["SyncLimit"]["UserNoVip"]
        else
            tLimit = _G["ServCfg"]["SyncLimit"]["UserVip"]
        end
    elseif self.m_type == RoleDef.UserType.Com then
        -- 企业账户
        if bVipLimit then
            tLimit = _G["ServCfg"]["SyncLimit"]["ComNoVip"]
        else
            tLimit = _G["ServCfg"]["SyncLimit"]["ComVip"]
        end
    else
        -- 企业子账户或者其他账户类型，完全限制
        tLimit = _G["ServCfg"]["SyncLimit"]["AllLimit"]
    end
    return tLimit
end

-- 通过 appP 获取 platID
function CRole:FindPlatID(appP)
    local platID = RoleDef.Platform.None
    if appP and RoleDef.Platform[appP] then
        platID = RoleDef.Platform[appP]
    end
    return platID
end

-- 销毁
function CRole:Destroy()
    self.m_Init = false
end


-- 增加一条 普通log 记录
function CRole:AddLogNormal(uid, cV, sV, ip, plat, operator, eventReason, eventType, eventTime, extra)
    local args = {}
    args.action = "AddLogNormal"
    args.uid = uid
    args.cVersion = cV
    args.sVersion = sV
    args.ipAddr = ip
    args.platID = plat
    args.operator = operator
    args.eventReason = eventReason
    args.eventType = eventType
    args.eventTime = eventTime
    if type(extra) == 'string' and #extra > 0 then
        args.extra = extra
    end
    local logRet = ReqEx.ReqLogS(args, nil)
    --print(logRet)
end

-- 增加一条 账号log 记录
function CRole:AddLogAccount(uid, cV, sV, ip, plat, operator, eventReason, eventType, eventTime, location)
    local args = {}
    args.action = "AddLogAccount"
    args.uid = uid
    args.cVersion = cV
    args.sVersion = sV
    args.ipAddr = ip
    args.platID = plat
    args.operator = operator
    args.eventReason = eventReason
    args.eventType = eventType
    args.eventTime = eventTime
    args.location = ""
    if type(location) == 'string' and #location > 0 then
        args.location = location
    end

    local logRet = ReqEx.ReqLogS(args, nil)
    --print(logRet)
end

-- 增加一条 充值log 记录
function CRole:AddLogCharge(uid, cV, sV, ip, plat, operator, eventReason, eventType, eventTime, trade_no, cre_time, trade_pid, total_amount, payway, paymod)
    local args = {}
    args.action = "AddLogCharge"
    args.uid = uid
    args.cVersion = cV
    args.sVersion = sV
    args.ipAddr = ip
    args.platID = plat
    args.operator = operator
    args.eventReason = eventReason
    args.eventType = eventType
    args.eventTime = eventTime
    args.tradeno = trade_no
    args.createTime = cre_time
    args.pid = trade_pid
    args.amount = total_amount
    args.payway = payway
    args.paymod = paymod
    local logRet = ReqEx.ReqLogS(args, nil)
    --print(logRet)
end

-- 账号 log
function CRole:LogAccount(eventType)
    local location = ""
    local eventReason = self.m_action
    self:AddLogAccount(self.m_uid, self.m_cVersion, self.m_sVersion, self.m_ipAddr, self.m_platID, self.m_operator, 
        eventReason, eventType, os.time(), location)
end

-- 充值 log
function CRole:LogCharge(eventType, trade_no, cre_time, trade_pid, total_amount, payway, paymod)
    local eventReason = self.m_action
    self:AddLogCharge(self.m_uid, self.m_cVersion, self.m_sVersion, self.m_ipAddr, self.m_platID, self.m_operator, 
        eventReason, eventType, os.time(), trade_no, cre_time, trade_pid, total_amount, payway, paymod)
end

-- 普通 log
function CRole:LogNormal(eventType, extra)
    local eventReason = self.m_action
    self:AddLogNormal(self.m_uid, self.m_cVersion, self.m_sVersion, self.m_ipAddr, self.m_platID, self.m_operator, 
        eventReason, eventType, os.time(), extra)
end
