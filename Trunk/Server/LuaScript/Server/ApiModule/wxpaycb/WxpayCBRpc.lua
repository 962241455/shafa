-- Rpc 协议系统
module("WxpayCBRpc", package.seeall)

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
    -- wxpay 使用 post 方法 回调通知
    local content = body
    if (not body) and bodyFile then
        local fh, err = io.open(bodyFile, "r")
        assert(fh, err)
        fh:seek("set")
        content = fh:read("*a")
        fh:close()
    end
    --[[
    if next(args) then
        content = ngx.encode_args(args)
    else
        if (not body) and bodyFile then
            local fh, err = io.open(bodyFile, "r")
            assert(fh, err)
            fh:seek("set")
            content = fh:read("*a")
            fh:close()
        end
    end
    --]]

    local data = ApiPayMgr.WxPayQRNotify(content)
    return data
end
