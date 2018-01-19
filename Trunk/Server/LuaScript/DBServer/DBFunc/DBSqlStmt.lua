-- SQL statement （sql 语句）

module("DBSqlStmt", package.seeall)

-- 参数类型检查
-- 's': 字符串
-- 'd': 数字
-- 'f': 小数
function CheckArgs(check, ... )
    local args = {...}
    if type(check) ~= 'string' then
        check = ""
    end
    local len = #check --string.len(check)
    local argslen = #args
    if argslen ~= len then
        assert(false, string.format("check args len: (%d, %d)", len, argslen))
    end

    for i=1, len, 1 do
        local ck = string.sub(check, i, i)
        if ck == "d" and type(args[i]) == 'number' then
            --
        elseif ck == "f" and type(args[i]) == 'number' then
            --
        elseif ck == "s" and type(args[i]) == 'string' then
            --
        else
            assert(false, string.format("unknown type: (%d, %s) %s", i, ck, tostring(args[i])))
        end
    end
end
-- 执行 sql 语句
function DoSql(oMyFunc, est_nrows, sqlFormat, ...)
    assert(oMyFunc and oMyFunc:IsClass(MyFunc), "oMyFunc is not validate !")
    CheckArgs(sqlFormat[2], ...)
    local sql = string.format(sqlFormat[1], ...)
    --print("========\n", sql)
    return oMyFunc:query(sql, est_nrows)
end


--[[ ========================== 短信验证码 ========================== ]]
-- 查询
local sQueryIdtc = 
{
    [1] = "select * from tbl_idtc where phno = '%s';",
    [2] = "s"
}
function QueryIdtc(oMyFunc, phno)
    local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sQueryIdtc, phno)
    return ret[1]
end

-- 更新使用标志 flag
local sUpdateIdtcFlag = 
{
    [1] = "update tbl_idtc set flag = %d where phno = '%s';",
    [2] = "ds"
}
function UpdateIdtcFlag(oMyFunc, phno, flag)
    return DoSql(oMyFunc, nil, sUpdateIdtcFlag, flag, phno)
end

-- 加入
local sAddIdtc = 
{
    [1] = "insert into tbl_idtc(phno, idtc, idtcTime, flag, extra) \
        select '%s', '%s', %d, 0, '%s' from empty \
        where not exists (select * from tbl_idtc where tbl_idtc.phno = '%s');",
    [2] = "ssdss"
}
function AddIdtc(oMyFunc, phno, idtc, idtcTime, extra)
    if type(extra) ~= 'string' then
        extra = ""
    end
    return DoSql(oMyFunc, nil, sAddIdtc, phno, idtc, idtcTime, extra, phno)
end

-- 修改
local sModifyIdtc = 
{
    [1] = "update tbl_idtc set idtc = '%s', idtcTime = %d, flag = 0, extra = '%s' where phno = '%s';",
    [2] = "sdss"
}
function ModifyIdtc(oMyFunc, phno, idtc, idtcTime, extra)
    if type(extra) ~= 'string' then
        extra = ""
    end
    return DoSql(oMyFunc, nil, sModifyIdtc, idtc, idtcTime, extra, phno)
end


--[[ ========================== 账号管理 ========================== ]]
-- 账号注册
local sAccountRegister = 
{
    [1] = "insert into tbl_account(user, pass, type, date, token, tokenTime, nick, head, location, userip, expire_time) \
        select '%s', '%s', %d, now(), '%s', %d, '%s', '%s', '%s', '%s', %d from empty \
        where not exists (select * from tbl_account where tbl_account.user = '%s');",
    [2] = "ssdsdssssds"
}
function AccountRegister(oMyFunc, user, pass, rtype, token, tokenTime, nick, head, location, userip, expire_time)
    if type(nick) ~= 'string' or #nick <= 0 then
        nick = user
    end
    head = head or ""
    location = location or ""
    userip   = userip or ""
    expire_time = expire_time or 0
    return DoSql(oMyFunc, nil, sAccountRegister, user, pass, rtype, token, tokenTime, nick, head, location, userip, expire_time, user)
end

-- 账号查询
local sAccountQuery = 
{
    [1] = "select * from tbl_account where user = '%s';",
    [2] = "s"
}
function AccountQuery(oMyFunc, user)
    local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sAccountQuery, user)
    return ret[1]
end

-- 查询用户数据
local sAccountQueryID = 
{
    [1] = "select * from tbl_account where uid = %d and token = '%s';",
    [2] = "ds"
}
function AccountQueryID(oMyFunc, uid, token)
    local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sAccountQueryID, uid, token)
    return ret[1]
end

-- 使用user或者uid查询用户数据，若传入user，则以user为准。
local sQueryAccount = 
{
    [1] = "select * from tbl_account where %s;",
    [2] = "s"
}
function QueryAccount(oMyFunc, user, uid)
    local condition = nil
    if type(user) == 'string' and #user > 0 then
        condition = string.format("user = '%s'", user)
    elseif type(uid) == 'number' and uid > 0 then
        condition = string.format("uid = %d", uid)
    else
        return nil
    end
    local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sQueryAccount, condition)
    return ret[1]
end

-- 账号密码修改
local sAccountModifyPass = 
{
    [1] = "update tbl_account set pass = '%s' where user = '%s';",
    [2] = "ss"
}
function AccountModifyPass(oMyFunc, user, newPass)
    return DoSql(oMyFunc, nil, sAccountModifyPass, newPass, user)
end

-- 更新 令牌
local sUpdateToken = 
{
    [1] = "update tbl_account set tokenTime = %d, token ='%s' where user = '%s';",
    [2] = "dss"
}
function UpdateToken(oMyFunc, user, token, tokenTime)
    return DoSql(oMyFunc, nil, sUpdateToken, tokenTime, token, user)
end

-- 更新头像和昵称
local sModifyHeadAndNick = 
{
    [1] = "update tbl_account set %s where uid = %d and token = '%s';",
    [2] = "sds"
}
function ModifyHeadAndNick(oMyFunc, uid, token, nick, head)
    local tv = {}
    if type(nick) == 'string' and #nick > 0 then
        table.insert(tv, string.format("nick = '%s'", nick))
    end
    if type(head) == 'string' and #head > 0 then
        table.insert(tv, string.format("head = '%s'", head))
    end
    assert(#tv > 0, "ModifyHeadAndNick error: no args!")
    local sv = table.concat(tv, " and ")
    return DoSql(oMyFunc, nil, sModifyHeadAndNick, sv, uid, token)
end

-- 查询符合条件用户数据
local sQueryUser = 
{
    [1] = "select * from tbl_account where %s";
    [2] = "s"
}
function QueryUser(oMyFunc, uid, token, user, pass, rtype, status, owner_uid, nick)
    local tv = {}
    if type(uid) == 'number' and uid > 0 then
        table.insert(tv, string.format("uid = %d", uid))
    end
    if type(token) == 'string' and #token > 0 then
        table.insert(tv, string.format("token = '%s'", token))
    end
    if type(user) == 'string' and #user > 0 then
        table.insert(tv, string.format("user = '%s'", user))
    end
    if type(pass) == 'string' and #pass > 0 then
        table.insert(tv, string.format("pass = '%s'", pass))
    end
    if type(rtype) == 'number' and rtype >= 0 then
        table.insert(tv, string.format("type = %d", rtype))
    end
    if type(status) == 'number' and status >= 0 then
        table.insert(tv, string.format("status = %d", status))
    end
    if type(owner_uid) == 'number' and owner_uid >= 0 then
        table.insert(tv, string.format("owner_uid = %d", owner_uid))
    end
    if type(nick) == 'string' and #nick > 0 then
        table.insert(tv, string.format("nick = '%s'", nick))
    end

    assert(#tv > 0, "QueryAccountAuth error: no args!")
    local sv = table.concat(tv, " and ")
    return DoSql(oMyFunc, nil, sQueryUser, sv)
end




--[[ ========================== 企业账户&授权相关 ========================== ]]
-- 查询授权
local sQueryAccountAuth = 
{
    [1] = "select * from tbl_account_auth where %s";
    [2] = "s"
}
function QueryAccountAuth(oMyFunc, auth_code, auth_type, auth_status, sub_uid, com_uid, auth_uid)
    local tv = {}
    if type(auth_code) == 'string' and #auth_code > 0 then
        table.insert(tv, string.format("auth_code = '%s'", auth_code))
    end
    if type(auth_type) == 'number' and auth_type >= 0 then
        table.insert(tv, string.format("auth_type = %d", auth_type))
    end
    if type(auth_status) == 'number' and auth_status >= 0 then
        table.insert(tv, string.format("auth_status = %d", auth_status))
    end
    if type(sub_uid) == 'number' and sub_uid >= 0 then
        table.insert(tv, string.format("sub_uid = %d", sub_uid))
    end
    if type(com_uid) == 'number' and com_uid >= 0 then
        table.insert(tv, string.format("com_uid = %d", com_uid))
    end
    if type(auth_uid) == 'number' and auth_uid >= 0 then
        table.insert(tv, string.format("auth_uid = %d", auth_uid))
    end
    assert(#tv > 0, "QueryAccountAuth error: no args!")
    local sv = table.concat(tv, " and ")
    return DoSql(oMyFunc, nil, sQueryAccountAuth, sv)
end

-- 个人账户删除归属于它的 所有完全无用的 企业账户
local sDelComAcount = 
{
    [1] = "delete t1.* from tbl_account t1 left join tbl_account_auth t2 on t1.uid = t2.com_uid \
        where t1.owner_uid = %d and t1.type = 1 and t2.auth_code is null;",
    [2] = "d"
}
-- 个人账户删除归属于它的 所有完全无用的 企业子账户
local sDelSubAcount = 
{
    [1] = "delete t1.* from tbl_account t1 left join tbl_account_auth t2 on t1.uid = t2.sub_uid \
        where t1.owner_uid = %d and t1.type = 2 and t2.auth_code is null;",
    [2] = "d"
}
-- 个人账户增加一个企业账户
local sAddComAcount = 
{
    [1] = "insert into tbl_account(type, status, user, pass, nick, head, owner_uid, token, tokenTime, userip, location, date, expire_time) \
        select 1, 0, '%s', t1.pass, '%s', '%s', t1.uid, t1.token, t1.tokenTime, t1.userip, t1.location, now(), %d \
        from tbl_account t1 where t1.uid = %d and t1.token = '%s' and t1.type = 0 \
        and not exists (select * from tbl_account t2 where t2.owner_uid = %d and t2.status = 0 and t2.type = 1);",
    [2] = "sssddsd"
}
-- 个人账户增加一个企业子账户
local sAddSubAcount = 
{
    [1] = "insert into tbl_account(type, status, user, pass, nick, head, owner_uid, token, tokenTime, userip, location, date, expire_time) \
        select 2, 0, '%s', t1.pass, '%s', '%s', t1.uid, t1.token, t1.tokenTime, t1.userip, t1.location, now(), %d \
        from tbl_account t1 where t1.uid = %d and t1.token = '%s' and t1.type = 0 \
        and not exists (select * from tbl_account t2 where t2.owner_uid = %d and t2.status = 0 and t2.type = 2);",
    [2] = "sssddsd"
}
-- 个人账户创建企业账户的次数+1
local sAddComCnt = 
{
    [1] = "update tbl_account set com_cnt = com_cnt + 1 \
        where uid = %d and token = '%s';",
    [2] = "ds"
}
-- 企业账户增加老板授权
local sAddBossAuth = 
{
    [1] = "insert into tbl_account_auth(auth_code, auth_type, auth_status, grant_time, finish_time, com_uid, sub_uid, auth_uid) \
        select '%s', 1, 1, %d, %d, t1.uid, %d, t1.owner_uid \
        from tbl_account t1 where t1.uid = %d and t1.token = '%s' and t1.owner_uid = %d and t1.type = 1 and t1.status = 0 \
        and exists (select * from tbl_account t2 where t2.uid = %d and t2.owner_uid = %d and t2.type = 2 and t2.status = 0);",
    [2] = "sddddsddd"
}
-- 个人账户创建企业账户或者企业子账户
function CreateComOrSub(oMyFunc, uid, token, rtype, user, nick, head, expire_time)
    if type(expire_time) ~= 'number' or expire_time <= 0 then
        expire_time = 0
    end

    -- 先删除完全无用的，再增加新的
    if rtype == RoleDef.UserType.Com then
        local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sDelComAcount, uid)
        ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sAddComAcount, user, nick, head, expire_time, uid, token, uid)
    elseif rtype == RoleDef.UserType.Sub then
        nick = nick or user
        head = head or ""
        local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sDelSubAcount, uid)
        ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sAddSubAcount, user, nick, head, expire_time, uid, token, uid)
    else
        assert(false, "CreateComOrSub Error, rtype = " .. tostring(rtype))
    end
    local ret = QueryAccount(oMyFunc, user, nil)
    if ret and ret.user == user and ret.type == rtype and ret.status == 0 and ret.owner_uid == uid then
        return ret
    end
end
-- 个人账户创建企业账户
function CreateComAccount(oMyFunc, uid, token, sub_user, com_user, com_nick, com_head, com_expire_time, auth_code, grant_time, finish_time)
    local ret, com_uid, com_token, sub_uid, sub_token = nil, nil, nil, nil, nil
    -- 创建企业子账户
    ret = CreateComOrSub(oMyFunc, uid, token, RoleDef.UserType.Sub, sub_user)
    if not ret then return end
    sub_uid, sub_token = ret.uid, ret.token
    -- 创建企业账户
    ret = CreateComOrSub(oMyFunc, uid, token, RoleDef.UserType.Com, com_user, com_nick, com_head, com_expire_time)
    if not ret then return end
    com_uid, com_token = ret.uid, ret.token
    -- 增加老板授权
    local owner_uid, auth_uid = uid, uid
    local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sAddBossAuth, auth_code, grant_time, finish_time, sub_uid, 
        com_uid, com_token, owner_uid, sub_uid, owner_uid)
    -- 个人账户创建企业账户的次数+1
    ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sAddComCnt, uid, token)
    -- 查询授权
    ret, err, errno, sqlstate = QueryAccountAuth(oMyFunc, auth_code, 1, 1, sub_uid, com_uid, auth_uid)
    return ret[1]
end

-- 企业账户增加一个成员授权邀请，只针对 企业成员(auth_type=0)。
local sAddAccountAuth = 
{
    [1] = "insert into tbl_account_auth(auth_code, grant_time, finish_time, auth_uid, com_uid) \
        select '%s', %d, %d, %d, t1.uid \
        from tbl_account t1 where t1.uid = %d and t1.token = '%s' and t1.type = 1 and t1.status = 0;",
    [2] = "sdddds"
}
function AddAccountAuth(oMyFunc, uid, token, auth_code, grant_time, finish_time, auth_uid)
    local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sAddAccountAuth, auth_code, grant_time, finish_time, auth_uid, uid, token)
    ret, err, errno, sqlstate = QueryAccountAuth(oMyFunc, auth_code, 0, 0, nil, uid, auth_uid)
    return ret[1]
end

-- 企业账户删除一个成员授权，只针对 企业成员(auth_type=0)。
local sDelAccountAuth = 
{
    [1] = "delete t1.*, t2.* from tbl_account_auth t1 left join tbl_account t2 on t1.sub_uid = t2.uid \
        where t1.auth_type != 1 and t1.auth_uid = %d and t1.com_uid = \
        (select t4.uid from \
        (select t3.uid from tbl_account t3 where t3.uid = %d and t3.token = '%s' and t3.type = 1 and t3.status = 0) as t4);",
    [2] = "dds"
}
function DelAccountAuth(oMyFunc, uid, token, auth_uid)
    local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sDelAccountAuth, auth_uid, uid, token)
    ret, err, errno, sqlstate = QueryAccountAuth(oMyFunc, nil, nil, nil, nil, uid, auth_uid)
    return ret[1]
end

-- 企业账户拒绝授权申请，只针对 企业成员(auth_type=0)。
local sRefuseAccountApply = 
{
    [1] = "delete t1.*, t2.* from tbl_account_auth t1 left join tbl_account t2 on t1.sub_uid = t2.uid \
        where t1.auth_code = '%s' and t1.auth_type != 1 and t1.auth_status != 1 and t1.com_uid = \
        (select t4.uid from \
        (select t3.uid from tbl_account t3 where t3.uid = %d and t3.token = '%s' and t3.type = 1 and t3.status = 0) as t4);",
    [2] = "sds"
}
function RefuseAccountApply(oMyFunc, uid, token, auth_code)
    local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sRefuseAccountApply, auth_code, uid, token)
    ret, err, errno, sqlstate = QueryAccountAuth(oMyFunc, auth_code, nil, nil, nil, uid, nil)
    return ret[1]
end

-- 企业账户接受授权申请，只针对 企业成员(auth_type=0)。
local sAcceptAccountApply = 
{
    [1] = "update tbl_account_auth t1 inner join tbl_account t2 on t1.com_uid = t2.uid \
        set t1.auth_status = 1, t1.finish_time = %d, t1.sub_uid = %d \
        where t1.auth_code = '%s' and t1.auth_type != 1 and t1.auth_status = 3 \
        and t2.uid = %d and t2.token = '%s' and t2.type = 1 and t2.status = 0 \
        and t1.auth_uid = (select t3.owner_uid from tbl_account t3 where t3.uid = %d and t3.type = 2 and t3.status = 0);",
    [2] = "ddsdsd"
}
function AcceptAccountApply(oMyFunc, uid, token, auth_code, sub_user, finish_time)
    -- QueryAccountAuth(oMyFunc, auth_code, auth_type, auth_status, sub_uid, com_uid, auth_uid)
    local ret = QueryAccountAuth(oMyFunc, auth_code, 0, 3, nil, nil, nil)
    if not ret[1] then return end
    local auth_uid = ret[1].auth_uid
    -- QueryAccount(oMyFunc, user, uid)
    local ret = QueryAccount(oMyFunc, nil, auth_uid)
    if not ret then return end
    local auth_token = ret.token
    -- 先创建创建企业子账户，再接受授权申请
    local ret = CreateComOrSub(oMyFunc, auth_uid, auth_token, RoleDef.UserType.Sub, sub_user)
    if not ret then return end
    local sub_uid, sub_token = ret.uid, ret.token
    local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sAcceptAccountApply, finish_time, sub_uid, auth_code, uid, token, sub_uid)
    ret, err, errno, sqlstate = QueryAccountAuth(oMyFunc, auth_code, nil, 1, sub_uid, uid, nil)
    return ret[1]
end

-- 个人账户申请授权，只针对 企业成员(auth_type=0)。
local sAddAccountApply = 
{
    [1] = "insert into tbl_account_auth(auth_code, auth_status, grant_time, finish_time, com_uid, auth_uid) \
        select '%s', 3, %d, %d, %d, t1.uid \
        from tbl_account t1 where t1.uid = %d and t1.token = '%s' and t1.type = 0;",
    [2] = "sdddds"
}
function AddAccountApply(oMyFunc, uid, token, auth_code, grant_time, finish_time, com_uid)
    local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sAddAccountApply, auth_code, grant_time, finish_time, com_uid, uid, token)
    ret, err, errno, sqlstate = QueryAccountAuth(oMyFunc, auth_code, 0, 3, nil, com_uid, uid)
    return ret[1]
end

-- 个人账户拒绝授权，只针对 企业成员(auth_type=0)。
local sRefuseAccountAuth = 
{
    [1] = "delete t1.*, t2.* from tbl_account_auth t1 left join tbl_account t2 on t1.sub_uid = t2.uid \
        where t1.auth_code = '%s' and t1.auth_type != 1 and t1.auth_status != 1 and t1.auth_uid = \
        (select t4.uid from (select t3.uid from tbl_account t3 where t3.uid = %d and t3.token = '%s') as t4);",
    [2] = "sds"
}
function RefuseAccountAuth(oMyFunc, uid, token, auth_code)
    local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sRefuseAccountAuth, auth_code, uid, token)
    ret, err, errno, sqlstate = QueryAccountAuth(oMyFunc, auth_code, nil, nil, nil, nil, uid)
    return ret[1]
end

-- 个人账户接受授权，只针对 企业成员(auth_type=0)。
local sAcceptAccountAuth = 
{
    [1] = "update tbl_account_auth t1 inner join tbl_account t2 on t1.auth_uid = t2.uid \
        set t1.auth_status = 1, t1.finish_time = %d, t1.sub_uid = %d \
        where t1.auth_code = '%s' and t1.auth_type != 1 and t1.auth_status = 0 \
        and t2.uid = %d and t2.token = '%s' and t2.type = 0 \
        and t1.auth_uid = (select t3.owner_uid from tbl_account t3 where t3.uid = %d and t3.type = 2 and t3.status = 0);",
    [2] = "ddsdsd"
}
function AcceptAccountAuth(oMyFunc, uid, token, auth_code, sub_user, finish_time)
    -- 先创建创建企业子账户，再接受授权
    local ret = CreateComOrSub(oMyFunc, uid, token, RoleDef.UserType.Sub, sub_user)
    if not ret then return end
    local sub_uid, sub_token = ret.uid, ret.token
    local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sAcceptAccountAuth, finish_time, sub_uid, auth_code, uid, token, sub_uid)
    ret, err, errno, sqlstate = QueryAccountAuth(oMyFunc, auth_code, nil, 1, sub_uid, nil, uid)
    return ret[1]
end

-- 企业账户转让，老板权限的转移
local sTransferAccountAuth = 
{
    [1] = "update tbl_account_auth t1 inner join tbl_account_auth t2 \
        on t1.com_uid = t2.com_uid and t1.auth_type = 1 and t1.auth_status = 1 and t2.auth_status = 1 and t2.auth_uid = %d \
        inner join tbl_account t3 on t1.com_uid = t3.uid \
        set t2.auth_type = t1.auth_type, t1.auth_type = t2.auth_type, t3.owner_uid = t2.auth_uid \
        where t1.com_uid = (select t5.uid from \
            (select t4.uid from tbl_account t4 where t4.uid = %d and t4.token = '%s' and t4.type = 1 and t4.status = 0) as t5);",
    [2] = "dds"
}
function TransferAccountAuth(oMyFunc, uid, token, auth_uid)
    local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sTransferAccountAuth, auth_uid, uid, token)
    ret, err, errno, sqlstate = QueryAccountAuth(oMyFunc, nil, 1, 1, nil, uid, auth_uid)
    return ret[1]
end

-- 企业账户解散授权(Dismiss)。
local sDismissAccountAuth = 
{
    [1] = "update tbl_account_auth t1 inner join tbl_account t2 on t1.com_uid = t2.uid \
        set t1.auth_status = 2, t1.sub_uid = null, t2.status = 1 \
        where t2.uid = %d and t2.token = '%s';",
    [2] = "ds"
}
function DismissAccountAuth(oMyFunc, uid, token)
    local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sDismissAccountAuth, uid, token)
    ret, err, errno, sqlstate = QueryAccountAuth(oMyFunc, nil, nil, nil, nil, uid, nil)
    return ret
end

--[[
-- 企业账户重聚授权(Reunion)
local sReunionAccountAuth = 
{
    [1] = "update tbl_account_auth t1 inner join tbl_account t2 on t1.com_uid = t2.uid \
        set t1.auth_status = 0, t1.sub_uid = null, t2.status = 0 \
        where t2.uid = %d and t2.token = '%s' and t2.status = 1 and t2.type = 1 and t2.owner_uid = %d \
        and not exists (select * from tbl_account t3 where t3.owner_uid = %d and t3.status = 0 and (t3.type = 1 or t3.type = 2));",
    [2] = ""
}
]]

-- 企业账户获取所有成员信息
local sGetAllAccountAuth = 
{
    [1] = "select t1.*, t2.user, t2.nick, t2.head from tbl_account_auth t1 inner join tbl_account t2 on t1.auth_uid = t2.uid \
        where t1.com_uid = (select t3.uid from tbl_account t3 where t3.uid = %d and t3.token = '%s' and t3.type = 1);",
    [2] = "ds"
}
function GetAllAccountAuth(oMyFunc, uid, token)
    return DoSql(oMyFunc, nil, sGetAllAccountAuth, uid, token)
end

-- 个人账户（企业主）将自己的面料、沙发数据转移到企业账户中。
local sUserDataToComData = 
{
    [1] = "update tbl_account t1 inner join tbl_account t2 on t1.owner_uid = t2.uid \
        and t2.uid = %d and t2.token = '%s' and t1.uid = %d and t1.type = 1 and t1.status = 0 \
        inner join %s t3 on t2.uid = t3.uid set t3.uid = t1.uid;",
    [2] = "dsds"
}
function UserDataToComData(oMyFunc, uid, token, com_uid)
    local tbl_cloth = "tbl_cloth_info"
    local tbl_sofa = "tbl_sofa_info"
    local tbl_tag = "tbl_tag_info"
    local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sUserDataToComData, uid, token, com_uid, tbl_cloth)
    local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sUserDataToComData, uid, token, com_uid, tbl_sofa)
    local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sUserDataToComData, uid, token, com_uid, tbl_tag)
    return true
end

-- 企业账户将自己的面料、沙发数据转移到企业主（个人账户）中。
local sComDataToUserData = 
{
    [1] = "update %s t1 inner join tbl_account t2 on t1.uid = t2.uid set t1.uid = t2.owner_uid \
        where t2.uid = %d and t2.token = '%s' and t2.type = 1 and t2.status = 0;",
    [2] = "sds"
}
function ComDataToUserData(oMyFunc, uid, token)
    local tbl_cloth = "tbl_cloth_info"
    local tbl_sofa = "tbl_sofa_info"
    local tbl_tag = "tbl_tag_info"
    local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sComDataToUserData, tbl_cloth, uid, token)
    local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sComDataToUserData, tbl_sofa, uid, token)
    local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sComDataToUserData, tbl_tag, uid, token)
    return true
end




--[[ ========================== 会员、支付相关 ========================== ]]
-- 新增订单
local sAddTrade = 
{
    [1] = "insert into tbl_pay(trade_no, type, uid, pid, statu, amount, add_time, cre_time, extra) \
        select '%s', %d, uid, '%s', 0, %f, %d, %d, '%s' from tbl_account \
        where tbl_account.uid = %d and tbl_account.token = '%s' \
        and not exists (select * from tbl_pay where tbl_pay.trade_no = '%s');",
    [2] = "sdsfddsdss"
}
function AddTrade(oMyFunc, uid, token, trade_no, type, pid, amount, add_time, cre_time, extra)
    local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sAddTrade, trade_no, type, pid, amount, add_time, cre_time, extra, uid, token, trade_no)
    return ret
end

-- 完成订单
local sFinishTrade = 
{
    [1] = "update tbl_pay p inner join tbl_account a on p.uid = a.uid \
        set p.statu = 1, p.done_time = %d, a.total_amount = a.total_amount + p.amount, a.expire_time = case \
        when a.expire_time + p.add_time * 86400 > %d + p.add_time * 86400 then a.expire_time + p.add_time * 86400 \
        else %d + p.add_time * 86400 end \
        where p.trade_no = '%s';",
    [2] = "ddds"
}
function FinishTrade(oMyFunc, trade_no, done_time)
    local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sFinishTrade, done_time, done_time, done_time, trade_no)
    return ret
end

-- 删除订单
local sDelTrade = 
{
    [1] = "delete from tbl_pay where trade_no = '%s';",
    [2] = "s"
}
function DelTrade(oMyFunc, trade_no)
    local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sDelTrade, trade_no)
    return ret
end

-- 查询订单
local sQueryTrade = 
{
    [1] = "select * from tbl_pay where trade_no = '%s';",
    [2] = "s"
}
function QueryTrade(oMyFunc, trade_no)
    local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sQueryTrade, trade_no)
    return ret[1]
end





--[[ ========================== 面料管理 ========================== ]]
-- 获取用户所有标签信息
local sGetAllTag = 
{
    [1] = "select * from tbl_tag_info where uid = \
        (select tbl_account.uid from tbl_account where tbl_account.uid = %d and tbl_account.token = '%s');",
    [2] = "ds"
}
function GetAllTag(oMyFunc, uid, token)
    local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sGetAllTag, uid, token)
    return ret
end

-- 增加一个 tag 标签
local sAddTag = 
{
    [1] = "insert into tbl_tag_info(uid, guid, cid, mtime, time, name) \
        select uid, '%s', '%s', %d, '%s', '%s' from tbl_account \
        where tbl_account.uid = %d and tbl_account.token = '%s' \
        and not exists (select * from tbl_tag_info where tbl_tag_info.guid = '%s');",
    [2] = "ssdssdss"
}
function AddTag(oMyFunc, uid, token, guid, cid, name, time, mtime)
    mtime = tonumber(mtime) or os.time()
    local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sAddTag, guid, cid, mtime, time, name, uid, token, guid)
    return ret
end

-- 删除一个标签
local sDelTag = 
{
    [1] = "delete from tbl_tag_info where guid = '%s' and uid = \
        (select tbl_account.uid from tbl_account where tbl_account.uid = %d and tbl_account.token = '%s');",
    [2] = "sds"
}
function DelTag(oMyFunc, uid, token, guid)
    local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sDelTag, guid, uid, token)
    return ret
end

-- 通过标签名 查询一个标签
local sQueryTag = 
{
    [1] = "select * from tbl_tag_info where guid = '%s' and uid = \
        (select tbl_account.uid from tbl_account where tbl_account.uid = %d and tbl_account.token = '%s');",
    [2] = "sds"
}
function QueryTag(oMyFunc, uid, token, guid)
    local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sQueryTag, guid, uid, token)
    return ret[1]
end

-- 修改标签信息（名字等）
local sUpdateTag = 
{
    [1] = "update tbl_tag_info set %s where guid = '%s' and uid = \
        (select tbl_account.uid from tbl_account where tbl_account.uid = %d and tbl_account.token = '%s');",
    [2] = "ssds"
}
function UpdateTag(oMyFunc, uid, token, guid, name, time, mtime)
    mtime = tonumber(mtime) or os.time()

    local tv = {}
    table.insert(tv, string.format("mtime = %d", mtime))
    if type(name) == 'string' and #name > 0 then
        table.insert(tv, string.format("name = '%s'", name))
    end
    if type(time) == 'string' and #time > 0 then
        table.insert(tv, string.format("time = '%s'", time))
    end
    local sv = table.concat(tv, ", ")

    local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sUpdateTag, sv, guid, uid, token)
    return ret
end

-- 获取用户所有面料信息
local sGetAllClothInfo = 
{
    [1] = "select %s from tbl_cloth_info where uid = \
        (select tbl_account.uid from tbl_account where tbl_account.uid = %d and tbl_account.token = '%s');",
    [2] = "sds"
}
function GetAllClothInfo(oMyFunc, uid, token, cols)
    local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sGetAllClothInfo, cols, uid, token)
    return ret
end

-- 添加一条面料
local sAddCloth = 
{
    [1] = "insert into tbl_cloth_info(uid, guid, name, tag, mtime, time, path, scaleX, scaleY, cid, extra) \
        select uid, '%s', '%s', '%s', %d, '%s', '%s', %f, %f, '%s', '%s' from tbl_account \
        where tbl_account.uid = %d and tbl_account.token = '%s' \
        and not exists (select * from tbl_cloth_info where tbl_cloth_info.guid = '%s');",
    [2] = "sssdssffssdss"
}
function AddCloth(oMyFunc, uid, token, guid, name, tag, mtime, time, path, scaleX, scaleY, cid, extra)
    mtime = tonumber(mtime) or os.time()
    extra = extra or ""
    local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sAddCloth, guid, name, tag, mtime, 
                                            time, path, scaleX, scaleY, cid, extra, uid, token, guid)
    return ret
end

-- 删除一条面料
local sDelCloth = 
{
    [1] = "delete from tbl_cloth_info where guid = '%s' and uid = \
        (select tbl_account.uid from tbl_account where tbl_account.uid = %d and tbl_account.token = '%s');",
    [2] = "sds"
}
function DelCloth(oMyFunc, uid, token, guid)
    local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sDelCloth, guid, uid, token)
    return ret
end

-- 查询一条面料
local sQueryCloth = 
{
    [1] = "select %s from tbl_cloth_info where guid = '%s' and uid = \
        (select tbl_account.uid from tbl_account where tbl_account.uid = %d and tbl_account.token = '%s');",
    [2] = "ssds"
}
function QueryCloth(oMyFunc, uid, token, guid, cols)
    cols = cols or "*"
    local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sQueryCloth, cols, guid, uid, token)
    return ret[1]
end

-- 更新面料信息（名字、标签、缩放系数、额外数据）
local sUpdateCloth = 
{
    [1] = "update tbl_cloth_info set %s where guid = '%s' and uid = \
        (select tbl_account.uid from tbl_account where tbl_account.uid = %d and tbl_account.token = '%s');",
    [2] = "ssds"
}
function UpdateCloth(oMyFunc, uid, token, guid, mtime, name, tag, scaleX, scaleY, extra, path)
    mtime = tonumber(mtime) or os.time()
    scaleX = tonumber(scaleX) or nil
    scaleY = tonumber(scaleY) or nil

    local tv = {}
    table.insert(tv, string.format("mtime = %d", mtime))
    if type(name) == 'string' and #name > 0 then
        table.insert(tv, string.format("name = '%s'", name))
    end
    if type(tag) == 'string' and #tag > 0 then
        table.insert(tv, string.format("tag = '%s'", tag))
    end
    if scaleX ~= nil then
        table.insert(tv, string.format("scaleX = %f", scaleX))
    end
    if scaleY ~= nil then
        table.insert(tv, string.format("scaleY = %f", scaleY))
    end
    if extra ~= nil then
        table.insert(tv, string.format("extra = '%s'", extra))
    end
    if type(path) == 'string' and #path > 0 then
        table.insert(tv, string.format("path = '%s'", path))
    end

    local sv = table.concat(tv, ", ")
    local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sUpdateCloth, sv, guid, uid, token)
    return ret
end

---------------------- 批量处理 ----------------------
-- 批量删除标签
local sDelTagBatch = 
{
    [1] = "delete from tbl_tag_info where tag in (%s) and uid = \
        (select tbl_account.uid from tbl_account where tbl_account.uid = %d and tbl_account.token = '%s');",
    [2] = "sds"
}
function DelTagBatch(oMyFunc, uid, token, tagList)
    if type(tagList) == 'table' and #tagList > 0 then
        local sv = table.concat(tagList, "', '")
        sv = "'" .. sv .. "'"
        local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sDelTagBatch, sv, uid, token)
        return ret
    else
        return "DelTagBatch: Nothing to delete!"
    end
end

-- 获取用户所有面料信息的数量
local sGetAllClothInfoCnt = 
{
    [1] = "select count(*) cnt from tbl_cloth_info where uid = \
        (select tbl_account.uid from tbl_account where tbl_account.uid = %d and tbl_account.token = '%s');",
    [2] = "ds"
}
function GetAllClothInfoCnt(oMyFunc, uid, token)
    local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sGetAllClothInfoCnt, uid, token)
    return ret[1]
end

-- 获取用户所有 sofa 模型的数量
local sGetAllSofaModelCnt = 
{
    [1] = "select count(*) cnt from tbl_sofa_info where type = 0 and uid = \
        (select tbl_account.uid from tbl_account where tbl_account.uid = %d and tbl_account.token = '%s');",
    [2] = "ds"
}
function GetAllSofaModelCnt(oMyFunc, uid, token)
    local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sGetAllSofaModelCnt, uid, token)
    return ret[1]
end

-- 获取用户所有 sofa 配色的数量
local sGetAllSofaColorlCnt = 
{
    [1] = "select count(*) cnt from tbl_sofa_info where type = 1 and uid = \
        (select tbl_account.uid from tbl_account where tbl_account.uid = %d and tbl_account.token = '%s');",
    [2] = "ds"
}
function GetAllSofaColorlCnt(oMyFunc, uid, token)
    local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sGetAllSofaColorlCnt, uid, token)
    return ret[1]
end





--[[ ========================== 沙发模型管理 ========================== ]]
-- 增加一个 sofa 模型
local sAddSofa = 
{
    [1] = "insert into tbl_sofa_info(uid, guid, cid, type, name, mtime, time, data, icon) \
        select uid, '%s', '%s', %d, '%s', %d, '%s', '%s', '%s' from tbl_account \
        where tbl_account.uid = %d and tbl_account.token = '%s' \
        and not exists (select * from tbl_sofa_info where tbl_sofa_info.guid = '%s');",
    [2] = "ssdsdsssdss"
}
function AddSofa(oMyFunc, uid, token, guid, cid, ntype, mtime, time, name, data, icon)
    mtime = tonumber(mtime) or os.time()
    local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sAddSofa, guid, cid, ntype, name, mtime, time, data, icon, uid, token, guid)
    return ret
end

-- 删除一个 sofa 模型
local sDelSofa = 
{
    [1] = "delete from tbl_sofa_info where guid = '%s' and uid = \
        (select tbl_account.uid from tbl_account where tbl_account.uid = %d and tbl_account.token = '%s');",
    [2] = "sds"
}
function DelSofa(oMyFunc, uid, token, guid)
    local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sDelSofa, guid, uid, token)
    return ret
end

-- 修改一个 sofa 模型
local sUpdateSofa = 
{
    [1] = "update tbl_sofa_info set %s where guid = '%s' and uid = \
        (select tbl_account.uid from tbl_account where tbl_account.uid = %d and tbl_account.token = '%s');",
    [2] = "ssds"
}
function UpdateSofa(oMyFunc, uid, token, guid, mtime, time, name, data, icon)
    mtime = tonumber(mtime) or os.time()

    local tv = {}
    table.insert(tv, string.format("mtime = %d", mtime))
    if type(time) == 'string' and #time > 0 then
        table.insert(tv, string.format("time = '%s'", time))
    end
    if type(name) == 'string' and #name > 0 then
        table.insert(tv, string.format("name = '%s'", name))
    end
    if type(data) == 'string' and #data > 0 then
        table.insert(tv, string.format("data = '%s'", data))
    end
    if type(icon) == 'string' and #icon > 0 then
        table.insert(tv, string.format("icon = '%s'", icon))
    end

    local sv = table.concat(tv, ", ")
    local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sUpdateSofa, sv, guid, uid, token)
    return ret
end


-- 查询一个 sofa 模型
local sQuerySofa = 
{
    [1] = "select * from tbl_sofa_info where guid = '%s' and uid = \
        (select tbl_account.uid from tbl_account where tbl_account.uid = %d and tbl_account.token = '%s');",
    [2] = "sds"
}
function QuerySofa(oMyFunc, uid, token, guid)
    local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sQuerySofa, guid, uid, token)
    return ret[1]
end

-- 查询用户所有 sofa 模型
local sGetAllSofa = 
{
    [1] = "select * from tbl_sofa_info where uid = \
        (select tbl_account.uid from tbl_account where tbl_account.uid = %d and tbl_account.token = '%s');",
    [2] = "ds"
}
function GetAllSofa(oMyFunc, uid, token)
    local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sGetAllSofa, uid, token)
    return ret
end




--[[ ========================== 邮件 ========================== ]]
-- 获取用户所有的邮件消息
local sGetAllMail = 
{
    [1] = "select a.guid,a.title,a.summary,a.content,a.send_time,a.attachment,b.read_flag,b.recv_flag from tbl_mail a left join tbl_mail_status b on a.guid=b.mail_id and b.uid= %d where (recv_uid = \
        (select tbl_account.uid from tbl_account where tbl_account.uid = %d and tbl_account.token = '%s') or recv_uid=0) and type=%d and (expire_time> %d or expire_time=0) order by a.send_time ;",
    [2] = "ddsdd"
}
function GetAllMail(oMyFunc, uid, token,type,time)
   
    local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sGetAllMail, uid,uid, token,type, time)
     --print("GetAllMaildddddddddddddddd:",ret)
    return ret
end
-- 获取用户未读的系统通知的条数
local sGetCountMail = 
{
    [1] = "select count(*) `number` from tbl_mail a left join tbl_mail_status b on a.guid=b.mail_id and b.uid= %d where (recv_uid = \
        (select tbl_account.uid from tbl_account where tbl_account.uid = %d and tbl_account.token = '%s') or recv_uid=0) and type=%d and (expire_time> %d or expire_time=0) and b.read_flag is null;",
    [2] = "ddsdd"
}
function GetCountMail(oMyFunc, uid, token,type,time)
   
    local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sGetCountMail, uid,uid, token,type, time)
     --print("GetAllMaildddddddddddddddd:",ret)
    return ret[1]
end

-- 查询用户的一条邮件通知
local sGetOneMail = 
{
    [1] = "select a.guid,a.title,a.summary,a.content,a.send_time,a.attachment,b.read_flag,b.recv_flag  from tbl_mail a left join tbl_mail_status b on a.guid=b.mail_id and b.uid= %d   where (a.recv_uid = \
        (select tbl_account.uid from tbl_account where tbl_account.uid = %d and tbl_account.token = '%s') or a.recv_uid=0)and a.guid= '%s';",
    [2] = "ddss"
}
function GetOneMail(oMyFunc, uid,token, guid)
    local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sGetOneMail,uid, uid, token, guid)
    return ret[1]
end
-- 增加用户读取邮件的记录
local sAddMailTag = 
{
    [1] = "insert into tbl_mail_status(uid, mail_id, read_flag, read_time) select uid, %d, %d, %d from tbl_account \
          where tbl_account.uid = %d and tbl_account.token = '%s' ;",          
    [2] = "dddds"
}
function AddMailTag(oMyFunc, mail_id,read_flag,read_time,uid,token)
    --print("S2DBS.AddMailTagssss: ", uid,mail_id,read_flag,read_time,token)

    local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sAddMailTag, mail_id,read_flag,read_time,uid,token)
    return ret
end 

-- 更新用户读取邮件的记录
local sUpdateMailTag = 
{
     [1] = "update tbl_mail_status set read_flag = %d, read_time =%d where guid = '%s' ;",
    [2] = "dds"
}
function UpdateMailTag(oMyFunc, read_flag,read_time,guid)
    --print("S2DBS.AddMailTagssss: ", uid,mail_id,read_flag,read_time,token)

    local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sUpdateMailTag, read_flag,read_time,guid)
    return ret
end

-- 查询用户是否已经读取了邮件
local sQueryMailTag = 
{
    [1] = "select * from tbl_mail_status  where uid= \
    (select tbl_account.uid from tbl_account where tbl_account.uid = %d and tbl_account.token = '%s')and mail_id= %d ;",
    [2] = "dsd"
}
function QueryMailTag(oMyFunc, uid, token,mail_id)
    local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sQueryMailTag, uid,token, mail_id)
    return ret
end
-- 增加一个系统邮件
local sAddMail = 
{
    [1] = "insert into tbl_mail(nowTime,type,gmName, send_uid,recv_uid,title,summary,content,attachment,send_time,expire_time) \
           values(now(),%d,'%s',%d,%d,'%s','%s','%s','%s',%d,%d);",
    [2] = "dsddssssdd"
}
function AddMail(oMyFunc, type, gmName, send_uid,recv_uid,title,summary,content,attachment,send_time,expire_time)
    local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sAddMail, type, gmName, send_uid,recv_uid,title,summary,content,attachment,send_time,expire_time)
    return ret
end

-- 增加一个用户反馈邮件
local sAddUserFeedBack = 
{
    [1] = "insert into tbl_mail(nowTime,type,send_uid,recv_uid,title,summary,content,attachment,send_time) \
           select now(), %d,uid, %d,'%s','%s','%s','%s',%d from tbl_account where tbl_account.uid = %d and tbl_account.token = '%s' ;",
    [2] = "ddssssdds"
}
function AddUserFeedBack(oMyFunc, type,recv_uid,title,summary,content,attachment,send_time,uid,token)
    local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sAddUserFeedBack, type,recv_uid,title,summary,content,attachment,send_time,uid,token)
    return ret
end