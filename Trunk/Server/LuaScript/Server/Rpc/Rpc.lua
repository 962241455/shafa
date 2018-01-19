-- Rpc 协议系统
module("Rpc", package.seeall)

-- 检查 签名
function CheckSign()
    -- 是否需要检查协议签名。1：是；其他：否。默认 1
    local nSign = _G["ServCfg"]["check_sign"]
    if nSign ~= 1 then
        return 0
    end
    -- 从 header 中获取签名信息
    local headers = ngx.req.get_headers()
    --print(os.time(), nSign)
    --print(headers)
    local key  = headers["appKey"]
    local sign = headers["sign"]
    local time = headers["time"]
    local rand = headers["rand"]
    return ReqEx.CheckSign(key, time, rand, sign)
end

-- ngx.print: 输出响应
-- ngx.say: 输出响应，自动添加 "\n"
-- ngx.resp.get_headers: 获取响应头 ngx.header、ngx.header
-- ngx.req.get_headers: 获取请求头
-- 接受客户端的请求并处理
function Recv(args, body, bodyFile)
    --print("main args: ", args)
    --print("main body: ", tostring(body), tostring(bodyFile))
    --print("main req headers: ", ngx.req.get_headers())
    --print("main resp headers: ", ngx.resp.get_headers())
    --local appV = ngx.req.get_headers()["appV"] or "0.0.0"
    --print(appV)
    ngx.header["Content-Type"] = "text/html;charset=utf-8"
    --local data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}
    local fFunc = function()
        local n = CheckSign()
        if 0 ~= n then
            return {code = RetCode.SignatureErr[1], message = RetCode.SignatureErr[2], result = n}
        end
    	return _Recv(args, body, bodyFile)
    end
    local ok, ret = LuaEx.pcall(fFunc)
    if not ok then
        LuaEx.dump(ret)
        local data = {code = RetCode.SvrErr[1], message = RetCode.SvrErr[2], result = ret}
        ngx.print(TextCode.JsonEncode(data))
        --ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
    else
        if not ret then
            ngx.exit(ngx.HTTP_NOT_FOUND)
        elseif type(ret) == 'string' then
            if #ret <= 0 then
                ngx.exit(ngx.HTTP_NOT_FOUND)
            else
                ngx.print(ret)
            end
        else
            -- 发送结果到客户端
            local data = {code = ret.code, message = ret.message, result = ret.result}
            --data.workID = ngx.worker.pid()
            --data.servTime = os.time()
            ngx.print(TextCode.JsonEncode(data))
        end
    end
end

-- location main 的请求
function _Recv(args, body, bodyFile)
    -- url 参数
    if not LuaEx.IsTable(args) or LuaEx.IsNullOrEmpty(args.action) then
        return {code = RetCode.ActionNull[1], message = RetCode.ActionNull[2], result = ""}
    end
    -- 协议是否合法
    local action = args.action
    if #action >= 32 or action == RoleDef.GMAction or not LuaEx.IsFunction(_G["C2S"][action]) then
        return {code = RetCode.ActionErr[1], message = RetCode.ActionErr[2] .. ": " .. action, result = ""}
    end
    -- 创建角色
    local headers = ngx.req.get_headers()
    local appP = headers["appP"] or "Other"
    local cVersion = headers["appV"] or "0.0.0"
    local sVersion = _G["ServCfg"]["Version"]["MaxVersion"] or "0.0.0"
    local oRole = CRole:new()
    local data = oRole:Init(tonumber(args.uid), args.token, cVersion, sVersion, oRole:FindPlatID(appP), action)
    if data.code == RetCode.Success[1] then
        -- 执行
        data = _G["C2S"][action](oRole, args, body, bodyFile)
    end
    -- 销毁角色
    oRole:Destroy()
    return data
end
