-- LuaEx
module("LuaEx", package.seeall)

-- pcall 扩展
function pcall(fun, ...)
    local arg = {...}
    local fFunc = function()
        return {fun(unpack(arg, 1, table.maxn(arg)))}
    end
    local fErr = function(err)
        return debug.traceback(err, 2)
    end
    local ok, ret = xpcall(fFunc, fErr)
    if ok then
        return true, unpack(ret, 1, table.maxn(ret))
    else
        return false, ret
    end
end

function IsTable(value)
    return type(value) == 'table'
end

function IsString(value)
    return type(value) == 'string'
end

function IsNumber(value)
    return type(value) == 'number'
end

function IsBoolean(value)
    return type(value) == 'boolean'
end

function IsFunction(value)
    return type(value) == "function"
end

function IsLuaType(value, sTypeName)
    assert(IsString(sTYpeName))
    return type(value) == sTypeName
end

function IsInteger(value)
    if not IsNumber(value) then
        return false
    end
    
    local intPart = math.floor(value)
    return (value - intPart) == 0
end

function IsEmptyTable(tValue)
    assert(IsTable(tValue))
    for i,v in pairs(tValue) do
        return false
    end
    return true
end

function IsNullOrEmpty(s)
    if s == nil then
        return true
    end

    if type(s) ~= "string" then
        return false
    end

    return #s == 0
end

-- 每隔 count 个字符，就插入一个 replace 字符串
function WordWrap(data, count, replace)
    if type(data) == 'string' and string.len(data) > 0 and count > 0 and 
        type(replace) == 'string' and string.len(replace) > 0 then
        -- 
        local res, pos, len = "", -1, string.len(data)
        for i = 1, len, count do
            pos = i + count - 1
            if pos < len then
                res = res .. string.sub(data, i, pos) .. replace
            else
                res = res .. string.sub(data, i, len)
            end
        end
        return res
    else
        return data
    end
end


--[[ 为 nginx 服务器做的扩展 ]]
-- 随机数
local MaxInt = 1024*1024*1024*2-1 -- 2147483648-1
local randSeed = os.time() + tonumber(ngx.worker.pid())
function Random()
    math.randomseed(randSeed)
    randSeed = math.random(0, MaxInt)  -- 随机数
    return randSeed
end

-- lua 对象 序列化
function LuaStr(obj)
    if "table" == type(obj) then
        local sb = {}
        table.insert(sb, "{")
        for k, v in pairs(obj) do
            if "number" == type(k) then
                table.insert(sb, string.format("[%d]=", k))
            elseif "string" == type(k) then
                table.insert(sb, string.format("%s=", k))
            else
                table.insert(sb, string.format("[\"%s\"]=", tostring(k)))
            end
            --
            if "table" == type(v) then
                table.insert(sb, LuaStr(v))
            else
                table.insert(sb, tostring(v))
            end
            table.insert(sb, ",")
        end
        table.insert(sb, "}")
        return table.concat(sb)
    else
        return tostring(obj)
    end
end

-- 打印消息
function print( ... )
    local args = {...}
    local str = ""
    for i=1, table.maxn(args), 1 do
        str = str .. LuaStr(args[i]) .. ", "
    end
    ngx.log(ngx.STDERR, str)
    --ngx.log(ngx.NOTICE, str)
    --ngx.log(ngx.ERR, str)
end
_G["print"] = LuaEx.print

-- 崩溃信息
local dumpFlag = 0
local dumpTime = 0
function UpdateDumpFlag()
    local nCurrTime = os.time()
    if nCurrTime ~= dumpTime then
        dumpTime = nCurrTime
        dumpFlag = 0
    end
    dumpFlag = dumpFlag + 1
    return dumpTime
end
function dump( sInfo )
    if type(sInfo) ~= 'string' then
        return
    end

    LuaEx.print(sInfo)

    local pid = ngx.worker.pid()
    local dir = ngx.config.prefix() .. "/dump/"
    local time = os.date("%Y-%m-%d-%H-%M-%S", UpdateDumpFlag())
    local sFileName = dir .. time .. "_" .. dumpFlag .. "_".. pid .. ".dump"

    local file = io.open(sFileName, "w+")
    if not file then return end
    file:write(sInfo)
    file:close()
end
