-- request 扩展
module("ReqEx", package.seeall)

-- 公钥、秘钥
--local curTime = 1492099200 -- os.time({year = 2017, month = 4, day = 14, hour = 0, min = 0, sec = 0})
--local appKey  = "fd057336f31a7fbc5353e566f2af578b" -- TextCode.Md5Encode("publickey-mixapp" .. curTime)
--local secKey  = "1167b990d7a42834" -- string.sub(TextCode.Md5Encode("secretkey-mixapp" .. curTime), 1, 16)
local tKey = 
{
    -- client 2 server
    ["fd057336f31a7fbc5353e566f2af578b"] = "1167b990d7a42834",
}
-- 检查 签名
function CheckSign(key, time, rand, sign)
    --print(key, time, rand, sign)
    local curTime = os.time()
    if curTime < time - 300 or curTime > time + 300 then
        return 1
    end
    local appKey, secKey = nil, nil
    if tKey[key] then
        appKey = key
        secKey = tKey[key]
    else
        return 2
    end
    local check = TextCode.Md5Encode(secKey .. time .. rand)
    if check ~= sign then
        return 3
    end
    return 0
end


-- 子请求
function SubReq(uri, args, body, method, headers)
    if type(uri) ~= "string" or #uri == 0 then
        return
    end
    -- method、body、headers
    if method == nil then
        method = ngx.HTTP_POST
        if type(body) ~= "string" or #body == 0 then
            body = nil
            method = ngx.HTTP_GET
        end
    end
    if method == ngx.HTTP_POST then
        if type(body) ~= "string" or #body == 0 then
            body = ""
        end
    end
    if type(headers) ~= 'table' then
        headers = nil
    end
    -- 设置 headers：ngx.req.get_headers()、ngx.req.set_header()、ngx.req.clear_header()
    local oldHeaders = ngx.req.get_headers()
    if headers then
        for i, v in pairs(oldHeaders) do
            ngx.req.clear_header(i)
        end
        for i, v in pairs(headers) do
            ngx.req.set_header(i, v)
        end
    end
    -- 子请求
    local tOption = {}
    tOption.args = args or {}
    tOption.body = body
    tOption.method = method
    local oRet = ngx.location.capture(uri, tOption)
    -- 恢复 headers
    if headers then
        for i, v in pairs(headers) do
            ngx.req.clear_header(i)
        end
        for i, v in pairs(oldHeaders) do
            ngx.req.set_header(i, v)
        end
    end

    return oRet
end

-- 内部跳转。 uri ："/imgdown/img01.bytes"
function Goto(uri, args)
    if type(uri) ~= "string" or #uri == 0 then
    	assert(false, "Goto: uri is null!")
    end
    if type(args) ~= "table" then
    	args = nil
    end

    --return ngx.redirect("/main", 302)
    --return ngx.redirect("/main", 301)
    return ngx.exec(uri, args)
end


-- 跳转到 dbs DBServer
function ReqDBS(args, body, method, headers)
    local dbsUrl = _G["ServCfg"]["dbs_url"]
    assert(type(dbsUrl) == 'string' and #dbsUrl > 0, "dbsUrl nil!")

    local oRet = SubReq(dbsUrl, args, body, method, headers)
    if oRet.status == ngx.HTTP_OK then
        return oRet.body
    else
        return nil
    end
end

-- 跳转到 Log Server
function ReqLogS(args, body, method, headers)
    local logsUrl = _G["ServCfg"]["logs_url"]
    assert(type(logsUrl) == 'string' and #logsUrl > 0, "logsUrl nil!")

    local oRet = SubReq(logsUrl, args, body, method, headers)
    if oRet.status == ngx.HTTP_OK then
        return oRet.body
    else
        return nil
    end
end

-- 跳转到 fls FileSever
function ReqFLS(args, body, method, headers)
    local flsUrl = _G["ServCfg"]["fls_url"]
    assert(type(flsUrl) == 'string' and #flsUrl > 0, "flsUrl nil!")

    local oRet = SubReq(flsUrl, args, body, method, headers)
    if oRet.status == ngx.HTTP_OK then
        return oRet.body
    else
        return nil
    end
end
