-- 用户 地理位置 获取
module("UserLocationMgr", package.seeall)

-- 获取 IP 所在地理位置
function GetLocation(ip)
    if type(ip) ~= 'string' or #ip == 0 then
        ip = ""
    end
    -- 新浪地址分享
    local url = "/proxy/http/int.dpool.sina.com.cn/iplookup/iplookup.php?format=json&ip=" .. ip
    local oRet = ReqEx.SubReq(url)
    if oRet.status == ngx.HTTP_OK then
        local result = TextCode.JsonDecode(oRet.body)
        if type(result) == 'table' and tonumber(result.ret) == 1 then
            local addr = result.country .. " " .. result.city
            return addr
        end
    else
        print("=============", oRet, url)
    end
    return nil
end
