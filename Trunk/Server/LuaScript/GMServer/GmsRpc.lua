-- GmsRpc 协议系统
module("GmsRpc", package.seeall)

-- 接受客户端的请求并处理
function Recv(args, body, bodyFile)
    ngx.header["Content-Type"] = "text/html;charset=utf-8"
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
    -- GM 执行
    return GMMgr.Execute(args, body, bodyFile)
end
