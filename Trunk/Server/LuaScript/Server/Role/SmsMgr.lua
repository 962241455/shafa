-- 腾讯云 短信验证码
module("SmsMgr", package.seeall)

-- 发送验证码
function SendIdtc(user, idtc, timelimit)
	return QCloudSmsSend(user, idtc, timelimit)
end

---------------------- 腾讯云 短信验证码 ----------------------
-- 发送短信
function QCloudSmsSend(user, idtc, timelimit)
	--user = tonumber(user) or 0
	idtc = tonumber(idtc) or 0
	timelimit = tonumber(timelimit) or 0
	if type(user) ~= 'string' or string.len(user) <= 0 or idtc < 100000 or idtc > 999999 or timelimit <= 0 then
		assert(false, string.format("Error: user=%s, idtc=%d, timelimit=%d", tostring(user), idtc, timelimit))
	end

	local idtcAppID = "1400036274"
	local idtcAppKey = "85de6c028debd29e65654204be927e57"
	local sendIdtcUrl = "/proxy/https/yun.tim.qq.com/v5/tlssmssvr/sendsms?sdkappid=%s&random=%s"
	local msgFormat = "【幻成科技】您的验证码为%d，%d分钟内有效。"
	local sigFormat = "appkey=%s&random=%s&time=%s&mobile=%s"
	local rand = 100000 + (LuaEx.Random() % 899999)  -- 随机数
	local mobile = tostring(user)
	local time = os.time()
	--local msg = string.format(msgFormat, idtc, timelimit)
	local sig = TextCode.Sha256Encode(string.format(sigFormat, idtcAppKey, rand, time, mobile))
	local tReqBody = 
	{
		["tel"] = 
		{
			["nationcode"] = "86", 		-- 国家码
			["mobile"] = mobile 	-- 手机号码
		},

		--["type"] = 0, 	-- 0:普通短信;1:营销短信（强调：要按需填值，不然会影响到业务的正常使用）
		--["msg"] = msg, -- utf8编码
		["sign"] = "幻成科技", -- 短信签名，如果使用默认签名，该字段可缺省
		["tpl_id"] = 30346, -- 业务在控制台审核通过的模板ID。例如：您的验证码为{1}，{2}分钟内有效。
		["params"] = {idtc, timelimit},

		["sig"] = sig,
		["time"] = time, 	-- unix时间戳，请求发起时间，如果和系统时间相差超过10分钟则会返回失败
		["extend"] = "", 		-- 通道扩展码，可选字段，默认没有开通(需要填空)。
		["ext"] = "" 		-- 用户的session内容，腾讯server回包中会原样返回，可选字段，不需要就填空。
	}
	local reqBody = TextCode.JsonEncode(tReqBody)
	local url = string.format(sendIdtcUrl, idtcAppID, rand)
	-- 请求
    local oRet = ReqEx.SubReq(url, {}, reqBody, ngx.HTTP_POST)
    if oRet.status == ngx.HTTP_OK then
    	local jd = TextCode.JsonDecode(oRet.body)
    	if type(jd) == 'table' and tonumber(jd.result) == 0 then
    		--[[
			local result = jd.result -- 0表示成功(计费依据)，非0表示失败
			local errmsg = jd.errmsg -- result非0时的具体错误信息
			local sid = jd.sid -- 标识本次发送id，标识一次短信下发记录
			local fee = jd.fee -- 短信计费的条数
			local ext = jd.ext -- 用户的session内容，腾讯server回包中会原样返回
			--]]
			return {code = RetCode.Success[1], message = RetCode.Success[2], result = jd}
		elseif type(jd) == 'table' and tonumber(jd.result) == 1016 then
			-- 手机号码不存在或错误
			return {code = RetCode.UnvalidPhno[1], message = RetCode.UnvalidPhno[2], result = jd}
		else
			return {code = RetCode.Failed[1], message = RetCode.Failed[2], result = jd}
    	end
    else
		return {code = RetCode.SvrErr[1], message = RetCode.SvrErr[2], result = "GetIdtc Error! " .. tostring(oRet.status)}
    end
end





---------------------- 网易云 短信验证码 ----------------------
--[[
--local idtcAppKey = "66912374e6348a6c35468a3b24fc2b83"
--local idtcAppSecret = "3cb087f04783"
--local templateid = "3063652"
-- 测试用
local idtcAppSecret = "8ca5e78989ac"
local idtcAppKey = "d9c01f1fba885a8233a2b8bfd501b060"
local templateid = "3051560"
-- url
local sendIdtcUrl = "/proxy/https/api.netease.im/sms/sendcode.action"
local verifyIdtcUrl = "/proxy/https/api.netease.im/sms/verifycode.action"

-- 发送短信验证码
function SendIdtc(user)
	-- args
	local AppSecret = idtcAppSecret
	local AppKey = idtcAppKey
	local CurTime = os.time()
	math.randomseed(CurTime)
	local Nonce = math.random(100000, 999999)  -- 随机数
	local CheckSum = TextCode.Sha1Encode(AppSecret .. Nonce .. CurTime)
	-- body：mobile、codeLen、templateid、deviceId
	local data = string.format("templateid=%s&mobile=%s&codeLen=%d", templateid, user, 6)
	local args = {}
	local method = ngx.HTTP_POST
	local headers = {
		["AppKey"] = AppKey,
		["Nonce"] = Nonce,
		["CurTime"] = CurTime,
		["CheckSum"] = CheckSum,
		["Content-Type"] = "application/x-www-form-urlencoded;charset=utf-8"
	}
	local url = sendIdtcUrl
	-- 请求
    local oRet = ReqEx.SubReq(url, args, data, method, headers)
    if oRet.status == ngx.HTTP_OK then
    	local jd = TextCode.JsonDecode(oRet.body)
    	if type(jd) == 'table' and tonumber(jd.code) == 200 then
    		--local sendid = jd.msg
    		--local idtc = jd.obj
			return {code = RetCode.Success[1], message = RetCode.Success[2], result = jd}
    	end
		return {code = RetCode.Failed[1], message = RetCode.Failed[2], result = "GetIdtc: " .. tostring(jd.code)}
    else
		return {code = RetCode.SvrErr[1], message = RetCode.SvrErr[2], result = "GetIdtc Error! " .. tostring(oRet.status)}
    end
end

-- 校验短信验证码
function VerifyIdtc(user, idtc)
	-- args
	local AppSecret = idtcAppSecret
	local AppKey = idtcAppKey
	local CurTime = os.time()
	math.randomseed(CurTime)
	local Nonce = math.random(100000, 999999)  -- 随机数
	local CheckSum = TextCode.Sha1Encode(AppSecret .. Nonce .. CurTime)
	-- body：mobile、code
	local data = string.format("mobile=%s&code=%s", user, idtc)
	local args = {}
	local method = ngx.HTTP_POST
	local headers = {
		["AppKey"] = AppKey,
		["Nonce"] = Nonce,
		["CurTime"] = CurTime,
		["CheckSum"] = CheckSum,
		["Content-Type"] = "application/x-www-form-urlencoded;charset=utf-8"
	}
	local url = verifyIdtcUrl
	-- 请求
    local oRet = ReqEx.SubReq(url, args, data, method, headers)
    if oRet.status == ngx.HTTP_OK then
    	local jd = TextCode.JsonDecode(oRet.body)
    	if type(jd) == 'table' and tonumber(jd.code) == 200 then
			return {code = RetCode.Success[1], message = RetCode.Success[2], result = jd}
    	end
		return {code = RetCode.IdentifyCodeErr[1], message = RetCode.IdentifyCodeErr[2], result = jd}
    else
		return {code = RetCode.SvrErr[1], message = RetCode.SvrErr[2], result = "VerifyIdtc Error! " .. tostring(oRet.status)}
    end
end
--]]
