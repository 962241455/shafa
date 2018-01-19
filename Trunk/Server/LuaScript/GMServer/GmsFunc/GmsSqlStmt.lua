-- SQL statement （sql 语句）

module("GmsSqlStmt", package.seeall)

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


-- 查询所有GM账号
local sGetAllGM = 
{
    [1] = "select * from tbl_gms_account;",
    [2] = ""
}
function GetAllGM(oMyFunc)
    local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sGetAllGM)
    return ret, {err, errno, sqlstate}
end

-- 查询某个GM
local sQueryGM = 
{
    [1] = "select * from tbl_gms_account where name = '%s';",
    [2] = "s"
}
function QueryGM(oMyFunc, name)
    local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sQueryGM, name)
    return ret[1], {err, errno, sqlstate}
end

-- 增加GM账号
local sAddGM = 
{
    [1] = "insert into tbl_gms_account(name, pass, power, token, date) values('%s', '%s', %d, '%s', now());",
    [2] = "ssds"
}
function AddGM(oMyFunc, name, pass, power, token)
    local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sAddGM, name, pass, power, token)
    return ret, {err, errno, sqlstate}
end

-- 删除GM账号
local sDelGM = 
{
    [1] = "delete from tbl_gms_account where name = '%s';",
    [2] = "s"
}
function DelGM(oMyFunc, name)
    local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sDelGM, name)
    return ret, {err, errno, sqlstate}
end

-- 修改GM账号信息
local sModGM = 
{
    [1] = "update tbl_gms_account set %s where name = '%s';",
    [2] = "ss"
}
function ModGM(oMyFunc, name, pass, power, token)
    local tv = {}
    if type(pass) == 'string' and #pass > 0 then
        table.insert(tv, string.format("pass = '%s'", pass))
    end
    if type(power) == 'number' and power > 0 then
        table.insert(tv, string.format("power = %d", power))
    end
    if type(token) == 'string' and #token > 0 then
        table.insert(tv, string.format("token = '%s'", token))
    end
    if #tv <= 0 or type(name) ~= 'string' or #name <= 0 then
        return nil
    end

    local sv = table.concat(tv, ", ")
    local ret, err, errno, sqlstate = DoSql(oMyFunc, nil, sModGM, sv, name)
    return ret, {err, errno, sqlstate}
end
