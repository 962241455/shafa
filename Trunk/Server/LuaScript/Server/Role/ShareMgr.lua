-- ShareMgr 分享管理
module("ShareMgr", package.seeall)

-- 分享
function Share(oRole, info)
	assert(oRole:IsClass(CRole) and oRole.m_Init, "oRole is not validate !")
	local uid, token = oRole.m_uid, oRole.m_token

	if type(info) ~= 'string' or #info <= 0 then
		info = "{}"
	end
	info = TextCode.JsonEncode(TextCode.JsonDecode(info))
	-- 分享 log
    oRole:LogNormal(LogDef.EventType.Share, info)

	local data = {code = RetCode.Success[1], message = RetCode.Success[2], result = ""}
	return data
end
