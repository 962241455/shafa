-- Rpc 协议系统
module("DBRpc", package.seeall)

-- 接受客户端的请求并处理
function Recv(args, body, bodyFile)
    local fFunc = function()
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
            ngx.print(ret)
        else
            -- 发送结果到客户端
            ngx.print(TextCode.JsonEncode(ret))
        end
    end
end

function _Recv(args, body, bodyFile)
	-- 参数判断
    if not LuaEx.IsTable(args) or LuaEx.IsNullOrEmpty(args.action) or not LuaEx.IsFunction(_G["S2DBS"][args.action]) then
    	assert(false, "DBServer Action Error : " .. (args.action or "nil"))
    end
    -- 执行
    return _G["S2DBS"][args.action](args, body, bodyFile)
end
