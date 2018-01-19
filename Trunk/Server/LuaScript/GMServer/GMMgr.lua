-- GMMgr
module("GMMgr", package.seeall)

-- 获取GM账号信息
function QueryGM(name)
    local data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}
    if type(name) ~= 'string' or #name <= 0 then
        return data
    end

    if name == GMDef.SuperGM.name then
        GMDef.SuperGM.power = 0
        data = {code = RetCode.Success[1], message = RetCode.Success[2], result = GMDef.SuperGM}
        return data
    else
        data = GmsFunc.QueryGM(name)
        if data.code == RetCode.Success[1] and data.result.power > 0 then
            return data
        else
            data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}
            return data
        end
    end
end

-- 验证GM是否可用，如果传入pass，则忽略token
function VerifyGM(action, name, token, pass)
    local data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}
    if not action or not GMDef.GMList[action] or not _G["C2GMS"][action] then
        data = {code = RetCode.ActionErr[1], message = RetCode.ActionErr[2] .. ": " .. tostring(action), result = nil}
        return data
    end

    data = QueryGM(name)
    if data.code ~= RetCode.Success[1] then
        data = {code = RetCode.NoAccount[1], message = RetCode.NoAccount[2], result = nil}
    elseif data.result.power > GMDef.GMList[action].power then
        data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = "权限不足"}
    else
        if type(pass) == 'string' and #pass > 0 then
            pass = TextCode.Md5Encode(pass)
            if data.result.pass ~= pass then
                data = {code = RetCode.PassWordErr[1], message = RetCode.PassWordErr[2], result = nil}
            end
        else
            if data.result.token ~= token then
                data = {code = RetCode.TokenCodeErr[1], message = RetCode.TokenCodeErr[2], result = nil}
            end
        end
    end

    return data
end

-- 创建并获取用户角色对象
function GetRole(user, uid, gmName)
    uid = tonumber(uid or "")
    local data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}
    if type(gmName) ~= 'string' or #gmName <= 0 then
        return nil, data
    end
    if type(user) ~= 'string' or #user <= 0 then
        user = nil
    end
    if type(uid) ~= 'number' or uid <= 0 then
        uid = nil
    end
    if not (user or uid) then
        return nil, data
    end

    local args = {}
    args.action = "QueryAccount"
    args.user = user
    args.uid = uid
    data = TextCode.JsonDecode(ReqEx.ReqDBS(args, nil))
    if data.code == RetCode.Success[1] then
        -- 创建角色
        local appP = ""
        local cVersion = ""
        local sVersion = _G["ServCfg"]["Version"]["MaxVersion"] or ""
        local oRole = CRole:new()
        data = oRole:Init(tonumber(data.result.uid), data.result.token, 
            cVersion, sVersion, oRole:FindPlatID(appP), RoleDef.GMAction, gmName)
        if data.code == RetCode.Success[1] then
            return oRole, data
        end
    end
    return nil, data
end

-- 销毁用户角色对象
function DestoryRole(oRole)
    if oRole and oRole:IsClass(CRole) then
        oRole:Destroy()
    end
end

-- GM 执行
function Execute(args, body, bodyFile)
    -- url 参数
    if not LuaEx.IsTable(args) or LuaEx.IsNullOrEmpty(args.action) then
        return {code = RetCode.ActionNull[1], message = RetCode.ActionNull[2], result = ""}
    end

    local action = args.action
    local gmName = args.gmName
    local gmToken = args.gmToken
    local gmPass = args.gmPass
    local user = args.user
    local uid = tonumber(args.uid)

    local data, oGM, oRole = nil, nil, nil
    data = GMMgr.VerifyGM(action, gmName, gmToken, gmPass)
    if data.code ~= RetCode.Success[1] then
        return data
    end
    oGM = CGMRole:new()
    oGM:Init(data.result.name, data.result.pass, data.result.token, data.result.power, data.result.date)
    oRole, data = GMMgr.GetRole(user, uid, gmName)
    data = _G["C2GMS"][action](oGM, oRole, args, body, bodyFile)
    GMMgr.DestoryRole(oRole)

    return data
end
