-- 版本管理器
module("VersionMgr", package.seeall)

-- v1 > v2，返回1。v1 = v2，返回0。v1 < v2，返回-1。
function CompareVersion(v1, v2)
	if type(v1) == 'string' and #v1 > 0 and type(v2) == 'string' and #v2 > 0 then
		local sV1, n = string.gsub(v1, "%.", "")
		local sV2, n = string.gsub(v2, "%.", "")
		local nV1 = tonumber(sV1)
		local nV2 = tonumber(sV2)
		--print(v1, v2, sV1, sV2, nV1, nV2)
		if not nV1 or not nV2 then
			return nil
		elseif nV1 > nV2 then
			return 1
		elseif nV1 == nV2 then
			return 0
		else
			return -1
		end
	end
	return nil
end

--  客户端是否为 IOS 审核版本
function IsIosReview()
	local headers = ngx.req.get_headers() or {}
    local appV = headers["appV"] or "0.0.0"
    local appP = headers["appP"] or "Other"
    if appP == "IOS" then
    	local currVersion = _G["ServCfg"]["Version"]["MaxVersion"]
    	local cp = CompareVersion(appV, currVersion)
		--print(appV, appP, cp)
    	if cp and cp == 1 then
    		return true
    	end
    end
    return false
end

-- 不同版本号，对于密码的保护措施不同
function DecodePwd(pass)
    -- 0.0.0 的老版本没有密码保护措施
	--local headers = ngx.req.get_headers() or {}
    --local appV = headers["appV"] or "0.0.0"

    pass = TextCode.Base64Decode(pass)
    pass = TextCode.Md5Encode(pass)
    return pass
end

function GetServerVersion()
	return TextCode.JsonEncode(_G["ServCfg"]["Version"])
end
