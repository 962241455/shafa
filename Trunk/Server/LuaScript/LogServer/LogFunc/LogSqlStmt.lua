-- SQL statement （sql 语句）

module("LogSqlStmt", package.seeall)

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


-- 普通log记录
local sAddLogNormal = 
{
    [1] = "insert into tbl_log_normal(nowTime, uid, eventType, eventReason, eventTime, platID, operator, ipAddr, sVersion, cVersion, extra) \
        values(now(), %d, %d, '%s', %d, %d, '%s', '%s', '%s', '%s', '%s');",
    [2] = "ddsddsssss"
}
function AddLogNormal(oMyFunc, uid, eventType, eventReason, eventTime, platID, operator, ipAddr, sVersion, cVersion, extra)
    return DoSql(oMyFunc, nil, sAddLogNormal, uid, eventType, eventReason, eventTime, platID, operator, ipAddr, sVersion, cVersion, extra)
end

-- 账号log记录
local sAddLogAccount = 
{
    [1] = "insert into tbl_log_account(nowTime, uid, eventType, eventReason, eventTime, platID, operator, ipAddr, sVersion, cVersion, location) \
        values(now(), %d, %d, '%s', %d, %d, '%s', '%s', '%s', '%s', '%s');",
    [2] = "ddsddsssss"
}
function AddLogAccount(oMyFunc, uid, eventType, eventReason, eventTime, platID, operator, ipAddr, sVersion, cVersion, location)
    return DoSql(oMyFunc, nil, sAddLogAccount, uid, eventType, eventReason, eventTime, platID, operator, ipAddr, sVersion, cVersion, location)
end

-- 充值log记录
local sAddLogCharge = 
{
    [1] = "insert into tbl_log_charge(nowTime, uid, eventType, eventReason, eventTime, platID, operator, ipAddr, sVersion, cVersion, \
        tradeno, createTime, pid, amount, payway, paymod) \
        values(now(), %d, %d, '%s', %d, %d, '%s', '%s', '%s', '%s', '%s', %d, '%s', %f, %d, %d);",
    [2] = "ddsddsssssdsfdd"
}
function AddLogCharge(oMyFunc, uid, eventType, eventReason, eventTime, platID, operator, ipAddr, sVersion, cVersion, tradeno, createTime, pid, amount, payway, paymod)
    return DoSql(oMyFunc, nil, sAddLogCharge, uid, eventType, eventReason, eventTime, platID, operator, ipAddr, sVersion, cVersion, tradeno, createTime, pid, amount, payway, paymod)
end
