-- DBSqlFunc
module("DBFunc", package.seeall)

-- 获取 DB 的 MysqlFunc 对象
function GetDBMyFunc()
    local cfg = _G["ServCfg"]["DBSMysqlCfg"]
    local oFunc = MyFunc:new(cfg.db_host, cfg.db_port, 
        cfg.db_user, cfg.db_pwd, cfg.db_db, cfg.db_keepTime, cfg.db_ConnNum)
    return oFunc
end


--[[ ========================== 短信验证码 ========================== ]]
-- 保存短信验证码
function SaveIdtc(phno, idtc, idtcTime, extra, intervalTime)
	local oMyFunc = GetDBMyFunc()
	local data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}

	-- 先查询
	local ret, err = DBSqlStmt.QueryIdtc(oMyFunc, phno)
	if not ret then
		ret, err = DBSqlStmt.AddIdtc(oMyFunc, phno, idtc, idtcTime, extra)
		if not ret then
			data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}
		else
			data = {code = RetCode.Success[1], message = RetCode.Success[2], result = ""}
		end
	else
		local flag = tonumber(ret.flag)
		local lastTime = tonumber(ret.idtcTime)
		local currTime = tonumber(idtcTime)
		if flag == 0 and currTime > lastTime and currTime < lastTime + tonumber(intervalTime)  then
			-- 在规定间隔时间内不准再生成验证码
			data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}
		else
			ret, err = DBSqlStmt.ModifyIdtc(oMyFunc, phno, idtc, idtcTime, extra)
			if not ret then
				data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}
			else
				data = {code = RetCode.Success[1], message = RetCode.Success[2], result = ""}
			end
		end
	end

	oMyFunc:freeInstance()
	return data
end

-- 验证短信验证码
function VerifyIdtc(phno, idtc, currTime, expiredTime)
	local oMyFunc = GetDBMyFunc()
	local data = {code = RetCode.IdentifyCodeErr[1], message = RetCode.IdentifyCodeErr[2], result = ""}

	local ret, err = DBSqlStmt.QueryIdtc(oMyFunc, phno)
	if not ret then
		data = {code = RetCode.IdentifyCodeErr[1], message = RetCode.IdentifyCodeErr[2], result = ""}
	else
		idtc = tostring(idtc)
		currTime = tonumber(currTime)
		expiredTime = tonumber(expiredTime)
		local flag = tonumber(ret.flag)
		local time = tonumber(ret.idtcTime)
		local ck = tostring(ret.idtc)
		if ck == idtc and flag == 0 and currTime < time + expiredTime and currTime > time then
			data = {code = RetCode.Success[1], message = RetCode.Success[2], result = ""}
		else
			data = {code = RetCode.IdentifyCodeErr[1], message = RetCode.IdentifyCodeErr[2], result = ""}
		end
	end

	oMyFunc:freeInstance()
	return data
end

-- 使用短信验证码
function UseIdtc(phno, idtc, currTime, expiredTime)
	idtc = tostring(idtc)
	currTime = tonumber(currTime)
	expiredTime = tonumber(expiredTime)
	local oMyFunc = GetDBMyFunc()
	local data = {code = RetCode.IdentifyCodeErr[1], message = RetCode.IdentifyCodeErr[2], result = ""}

	local ret, err = DBSqlStmt.QueryIdtc(oMyFunc, phno)
	if ret then
		local flag = tonumber(ret.flag)
		local time = tonumber(ret.idtcTime)
		local ck = tostring(ret.idtc)
		if ck == idtc and flag == 0 and currTime <= time + expiredTime and currTime >= time then
			ret, err = DBSqlStmt.UpdateIdtcFlag(oMyFunc, phno, 1)
			if not ret then
				data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = ""}
			else
				data = {code = RetCode.Success[1], message = RetCode.Success[2], result = ""}
			end
		else
			data = {code = RetCode.IdentifyCodeErr[1], message = RetCode.IdentifyCodeErr[2], result = ""}
		end
	end

	oMyFunc:freeInstance()
	return data
end

-- 查询短信验证码
function QueryIdtc(phno)
	local oMyFunc = GetDBMyFunc()
	local data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}

	local ret, err = DBSqlStmt.QueryIdtc(oMyFunc, phno)
	if ret then
		data = {code = RetCode.Success[1], message = RetCode.Success[2], result = ret}
	end

	oMyFunc:freeInstance()
	return data
end


--[[ ========================== 账号管理 ========================== ]]
-- 验证 令牌
function CheckToken(oMyFunc, uid, token)
	local data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}
	-- 查询
	local ret, err = DBSqlStmt.AccountQueryID(oMyFunc, uid, token)
	if not ret then
		-- 令牌错误
		data.code = RetCode.TokenCodeErr[1]
		data.message = RetCode.TokenCodeErr[2]
		data.result = ""
	else
		data.code = RetCode.Success[1]
		data.message = RetCode.Success[2]
		data.result = ret
	end

	return data
end

-- 修正 令牌
function FixToken(oMyFunc, user, uid, currTime, expiredTime, newToken)
	local data = nil

	local ret, err = DBSqlStmt.QueryAccount(oMyFunc, user, uid)
	if not ret then
		-- 账号不存在
		data = {code = RetCode.NoAccount[1], message = RetCode.NoAccount[2], result = ""}
	else
		user, uid = ret.user, ret.uid
		local sToken, tokenTime = ret.token, ret.tokenTime
		if currTime > tokenTime + expiredTime or currTime < tokenTime then
			-- 保存新的口令 token
			sToken = newToken
			DBSqlStmt.UpdateToken(oMyFunc, user, sToken, currTime)
		end
		data = CheckToken(oMyFunc, uid, sToken)
	end

	return data
end

-- 账号注册
function Register (user, pass, rtype, token, tokenTime, nick, head, location, userip, expire_time)
	local oMyFunc = GetDBMyFunc()
	local data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}

	-- 先查询
	local ret, err = DBSqlStmt.AccountQuery(oMyFunc, user)
	if ret then
		-- 已存在账号
		data = {code = RetCode.ExistAccount[1], message = RetCode.ExistAccount[2], result = nil}
	else
		-- 注册
		ret, err = DBSqlStmt.AccountRegister(oMyFunc, user, pass, rtype, token, tokenTime, nick, head, location, userip, expire_time)
		-- 查询 uid、token
		ret, err = DBSqlStmt.AccountQuery(oMyFunc, user)
		if not ret then
			-- 服务器错误
			data = {code = RetCode.SvrErr[1], message = RetCode.SvrErr[2], result = err}
		else
			data = {code = RetCode.Success[1], message = RetCode.Success[2], result = ret}
		end
	end

	oMyFunc:freeInstance()
	return data
end

-- 账号验证
function Verify (user, pass, currTime, expiredTime, newToken)
	local oMyFunc = GetDBMyFunc()
	local data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}

	local ret, err = DBSqlStmt.AccountQuery(oMyFunc, user)
	if not ret then
		-- 账号不存在
		data = {code = RetCode.NoAccount[1], message = RetCode.NoAccount[2], result = nil}
	elseif ret.pass ~= pass then
		-- 密码错误
		data = {code = RetCode.PassWordErr[1], message = RetCode.PassWordErr[2], result = nil}
	else
		-- 更新 令牌
		data = FixToken(oMyFunc, user, nil, currTime, expiredTime, newToken)
	end

	oMyFunc:freeInstance()
	return data
end

-- 修改密码
function ModifyPass(user, pass)
	local oMyFunc = GetDBMyFunc()
	local data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}

	-- 先查询
	local ret, err = DBSqlStmt.AccountQuery(oMyFunc, user)
	if not ret then
		-- 账号不存在
		data.code = RetCode.NoAccount[1]
		data.message = RetCode.NoAccount[2]
		data.result = ""
	else
		local uid, token = ret.uid, ret.token
		-- 修改密码
		ret, err = DBSqlStmt.AccountModifyPass(oMyFunc, user, pass)
		if ret then
			data.code = RetCode.Success[1]
			data.message = RetCode.Success[2]
			data.result = {uid = uid, token = token}
		else
			data.code = RetCode.Failed[1]
			data.message = RetCode.Failed[2]
			data.result = ""
		end
	end

	oMyFunc:freeInstance()
	return data
end

-- 更新头像和昵称
function ModifyHeadAndNick(uid, token, nick, head)
	local oMyFunc = GetDBMyFunc()
	local data = CheckToken(oMyFunc, uid, token)

	-- 更新
    if data.code == RetCode.Success[1] then
    	local ret, err = DBSqlStmt.ModifyHeadAndNick(oMyFunc, uid, token, nick, head)
		ret, err = DBSqlStmt.AccountQueryID(oMyFunc, uid, token)
		if not ret then
			-- 令牌错误
			data = {code = RetCode.TokenCodeErr[1], message = RetCode.TokenCodeErr[2], result = nil}
		else
			data = {code = RetCode.Success[1], message = RetCode.Success[2], result = ret}
		end
    end

	oMyFunc:freeInstance()
	return data
end

-- 登录
function Login(uid, token, currTime, expiredTime, newToken)
	local oMyFunc = GetDBMyFunc()
	local data = CheckToken(oMyFunc, uid, token)

    if data.code == RetCode.Success[1] then
		-- 更新 令牌
		data = FixToken(oMyFunc, nil, uid, currTime, expiredTime, newToken)
    end

	oMyFunc:freeInstance()
	return data
end

-- 更新 令牌
function UpdateToken(user, uid, currTime, expiredTime, newToken)
	local oMyFunc = GetDBMyFunc()
	local data = FixToken(oMyFunc, user, uid, currTime, expiredTime, newToken)
	oMyFunc:freeInstance()
	return data
end

-- 查询用户数据
function AccountQueryID(uid, token)
	local oMyFunc = GetDBMyFunc()
	local data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}
	-- 查询
	local ret, err = DBSqlStmt.AccountQueryID(oMyFunc, uid, token)
	if not ret then
		-- 令牌错误
		data = {code = RetCode.TokenCodeErr[1], message = RetCode.TokenCodeErr[2], result = nil}
	else
		data = {code = RetCode.Success[1], message = RetCode.Success[2], result = ret}
	end

	oMyFunc:freeInstance()
	return data
end

-- 使用user或者uid查询用户数据，若传入user，则以user为准。
function QueryAccount(user, uid)
	local oMyFunc = GetDBMyFunc()
	local data = nil

	local ret, err = DBSqlStmt.QueryAccount(oMyFunc, user, uid)
	if not ret then
		-- 账号不存在
		data = {code = RetCode.NoAccount[1], message = RetCode.NoAccount[2], result = ""}
	else
		data = {code = RetCode.Success[1], message = RetCode.Success[2], result = ret}
	end

	oMyFunc:freeInstance()
	return data
end

-- 查询符合条件用户数据
function QueryUser(uid, token, user, pass, rtype, status, owner_uid, nick)
	local oMyFunc = GetDBMyFunc()
	local data = nil

	local ret, err = DBSqlStmt.QueryUser(oMyFunc, uid, token, user, pass, rtype, status, owner_uid, nick)
	if not ret then
		data = {code = RetCode.SvrErr[1], message = RetCode.SvrErr[2], result = ""}
	else
		data = {code = RetCode.Success[1], message = RetCode.Success[2], result = ret}
	end

	oMyFunc:freeInstance()
	return data
end




--[[ ========================== 企业账户&授权相关 ========================== ]]
-- 查询授权
function QueryAccountAuth(auth_code, auth_type, auth_status, sub_uid, com_uid, auth_uid)
	local oMyFunc = GetDBMyFunc()
	local data = nil

	local ret, err = DBSqlStmt.QueryAccountAuth(oMyFunc, auth_code, auth_type, auth_status, sub_uid, com_uid, auth_uid)
	if not ret then
		data = {code = RetCode.SvrErr[1], message = RetCode.SvrErr[2], result = err}
	else
		data = {code = RetCode.Success[1], message = RetCode.Success[2], result = ret}
	end

	oMyFunc:freeInstance()
	return data
end

-- 个人账户创建企业账户
function CreateComAccount(uid, token, sub_user, com_user, com_nick, com_head, com_expire_time, auth_code, grant_time, finish_time)
	local oMyFunc = GetDBMyFunc()
	local data = nil

	local ret = DBSqlStmt.CreateComAccount(oMyFunc, uid, token, sub_user, com_user, com_nick, com_head, com_expire_time, auth_code, grant_time, finish_time)
	if ret then
		data = {code = RetCode.Success[1], message = RetCode.Success[2], result = ret}
	else
		data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}
	end

	oMyFunc:freeInstance()
	return data
end

-- 企业账户增加一个成员授权邀请，只针对 企业成员(auth_type=0)。
function AddAccountAuth(uid, token, auth_code, grant_time, finish_time, auth_uid)
	local oMyFunc = GetDBMyFunc()
	local data = nil

	local ret = DBSqlStmt.AddAccountAuth(oMyFunc, uid, token, auth_code, grant_time, finish_time, auth_uid)
	if ret then
		data = {code = RetCode.Success[1], message = RetCode.Success[2], result = ret}
	else
		data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}
	end

	oMyFunc:freeInstance()
	return data
end

-- 企业账户删除一个成员授权，只针对 企业成员(auth_type=0)。
function DelAccountAuth(uid, token, auth_uid)
	local oMyFunc = GetDBMyFunc()
	local data = nil

	local ret = DBSqlStmt.DelAccountAuth(oMyFunc, uid, token, auth_uid)
	if ret then
		data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = ret}
	else
		data = {code = RetCode.Success[1], message = RetCode.Success[2], result = nil}
	end

	oMyFunc:freeInstance()
	return data
end

-- 企业账户拒绝授权申请，只针对 企业成员(auth_type=0)。
function RefuseAccountApply(uid, token, auth_code)
	local oMyFunc = GetDBMyFunc()
	local data = nil

	local ret = DBSqlStmt.RefuseAccountApply(oMyFunc, uid, token, auth_code)
	if not ret then
		data = {code = RetCode.Success[1], message = RetCode.Success[2], result = ret}
	else
		data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = ret}
	end

	oMyFunc:freeInstance()
	return data
end

-- 企业账户接受授权申请，只针对 企业成员(auth_type=0)。
function AcceptAccountApply(uid, token, auth_code, sub_user, finish_time)
	local oMyFunc = GetDBMyFunc()
	local data = nil

	local ret = DBSqlStmt.AcceptAccountApply(oMyFunc, uid, token, auth_code, sub_user, finish_time)
	if ret then
		data = {code = RetCode.Success[1], message = RetCode.Success[2], result = ret}
	else
		data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}
	end

	oMyFunc:freeInstance()
	return data
end

-- 个人账户申请授权，只针对 企业成员(auth_type=0)。
function AddAccountApply(uid, token, auth_code, grant_time, finish_time, com_uid)
	local oMyFunc = GetDBMyFunc()
	local data = nil

	local ret = DBSqlStmt.AddAccountApply(oMyFunc, uid, token, auth_code, grant_time, finish_time, com_uid)
	if ret then
		data = {code = RetCode.Success[1], message = RetCode.Success[2], result = ret}
	else
		data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}
	end

	oMyFunc:freeInstance()
	return data
end

-- 个人账户拒绝授权，只针对 企业成员(auth_type=0)。
function RefuseAccountAuth(uid, token, auth_code)
	local oMyFunc = GetDBMyFunc()
	local data = nil

	local ret = DBSqlStmt.RefuseAccountAuth(oMyFunc, uid, token, auth_code)
	if ret then
		data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = ret}
	else
		data = {code = RetCode.Success[1], message = RetCode.Success[2], result = nil}
	end

	oMyFunc:freeInstance()
	return data
end

-- 个人账户接受授权，只针对 企业成员(auth_type=0)。
function AcceptAccountAuth(uid, token, auth_code, sub_user, finish_time)
	local oMyFunc = GetDBMyFunc()
	local data = nil

	local ret = DBSqlStmt.AcceptAccountAuth(oMyFunc, uid, token, auth_code, sub_user, finish_time)
	if ret then
		data = {code = RetCode.Success[1], message = RetCode.Success[2], result = ret}
	else
		data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}
	end

	oMyFunc:freeInstance()
	return data
end

-- 企业账户转让，老板权限的转移
function TransferAccountAuth(uid, token, auth_uid)
	local oMyFunc = GetDBMyFunc()
	local data = nil

	local ret = DBSqlStmt.TransferAccountAuth(oMyFunc, uid, token, auth_uid)
	if ret then
		data = {code = RetCode.Success[1], message = RetCode.Success[2], result = nil}
	else
		data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}
	end

	oMyFunc:freeInstance()
	return data
end

-- 企业账户解散授权(Dismiss)。
function DismissAccountAuth(uid, token)
	local oMyFunc = GetDBMyFunc()
	local data = nil

	local ret, err = DBSqlStmt.DismissAccountAuth(oMyFunc, uid, token)
	ret, err = DBSqlStmt.QueryAccountAuth(oMyFunc, nil, nil, RoleDef.AuthStatus.Normal, nil, uid, nil)
	if not ret then
		data = {code = RetCode.SvrErr[1], message = RetCode.SvrErr[2], result = err}
	elseif ret[1] then
		data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = ret}
	else
		data = {code = RetCode.Success[1], message = RetCode.Success[2], result = nil}
	end

	oMyFunc:freeInstance()
	return data
end

-- 企业账户获取所有成员信息
function GetAllAccountAuth(uid, token)
	local oMyFunc = GetDBMyFunc()
	local data = nil

	local ret = DBSqlStmt.GetAllAccountAuth(oMyFunc, uid, token)
	if ret then
		data = {code = RetCode.Success[1], message = RetCode.Success[2], result = ret}
	else
		data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}
	end

	oMyFunc:freeInstance()
	return data
end

-- 个人账户（企业主）将自己的面料、沙发数据转移到企业账户中。
function UserDataToComData(uid, token, com_uid)
	local oMyFunc = GetDBMyFunc()
	local data = nil

	local ret = DBSqlStmt.UserDataToComData(oMyFunc, uid, token, com_uid)
	if ret then
		data = {code = RetCode.Success[1], message = RetCode.Success[2], result = ret}
	else
		data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}
	end

	oMyFunc:freeInstance()
	return data
end

-- 企业账户将自己的面料、沙发数据转移到企业主（个人账户）中。
function ComDataToUserData(uid, token)
	local oMyFunc = GetDBMyFunc()
	local data = nil

	local ret = DBSqlStmt.ComDataToUserData(oMyFunc, uid, token)
	if ret then
		data = {code = RetCode.Success[1], message = RetCode.Success[2], result = ret}
	else
		data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}
	end

	oMyFunc:freeInstance()
	return data
end




--[[ ========================== 会员、支付相关 ========================== ]]
-- 新增订单
function AddTrade(uid, token, trade_no, type, pid, amount, add_time, cre_time, extra)
	local oMyFunc = GetDBMyFunc()
    local data = CheckToken(oMyFunc, uid, token)

    if data.code == RetCode.Success[1] then
    	local ret, err = DBSqlStmt.QueryTrade(oMyFunc, trade_no)
    	if not ret then
			ret, err = DBSqlStmt.AddTrade(oMyFunc, uid, token, trade_no, type, pid, amount, add_time, cre_time, extra)
			ret, err = DBSqlStmt.QueryTrade(oMyFunc, trade_no)
			if ret then
	    		data = {code = RetCode.Success[1], message = RetCode.Success[2], result = ret}
			else
				data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = "创建订单失败"}
			end
    	else
			data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = "已经存在的订单号：" .. (trade_no or "")}
    	end
    end

	oMyFunc:freeInstance()
	return data
end

-- 完成订单
function FinishTrade(trade_no, done_time)
	local oMyFunc = GetDBMyFunc()
	local data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}

    local ret, err = DBSqlStmt.QueryTrade(oMyFunc, trade_no)
    if ret and ret.statu == 0 then
	    ret, err = DBSqlStmt.FinishTrade(oMyFunc, trade_no, done_time)
	    ret, err = DBSqlStmt.QueryTrade(oMyFunc, trade_no)
	    if ret and ret.statu == 1 then
	    	data = {code = RetCode.Success[1], message = RetCode.Success[2], result = ret}
	    else
	    	data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = "订单支付失败"}
	    end
	else
		data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = "订单无效或者已经完成支付"}
	end

	oMyFunc:freeInstance()
	return data
end

-- 查询订单
function QueryTrade(uid, token, trade_no)
	local oMyFunc = GetDBMyFunc()
    local data = CheckToken(oMyFunc, uid, token)
    if data.code == RetCode.Success[1] then
	    local ret, err = DBSqlStmt.QueryTrade(oMyFunc, trade_no)
		if ret then
			data = {code = RetCode.Success[1], message = RetCode.Success[2], result = ret}
		else
			data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = "不存在的订单号：" .. (trade_no or "")}
		end
    end

	oMyFunc:freeInstance()
	return data
end



--[[ ========================== 面料标签管理 ========================== ]]
-- 获取用户所有标签信息
function GetAllTag(uid, token)
	local oMyFunc = GetDBMyFunc()
    local data = CheckToken(oMyFunc, uid, token)

    if data.code == RetCode.Success[1] then
		local ret, err = DBSqlStmt.GetAllTag(oMyFunc, uid, token)
		data = {code = RetCode.Success[1], message = RetCode.Success[2], result = ret or {}}
    end

	oMyFunc:freeInstance()
	return data
end

-- 增加一个 tag 标签.
local function _AddTag(oMyFunc, uid, token, guid, cid, name, time, mtime)
	local ret, err = DBSqlStmt.QueryTag(oMyFunc, uid, token, guid)
	if not ret then
		ret, err = DBSqlStmt.AddTag(oMyFunc, uid, token, guid, cid, name, time, mtime)
		ret, err = DBSqlStmt.QueryTag(oMyFunc, uid, token, guid)
	end
	if ret then
		return {code = RetCode.Success[1], message = RetCode.Success[2], result = ret}
	else
		return {code = RetCode.FailedAddTag[1], message = RetCode.FailedAddTag[2], result = {cid = cid, name = name}}
	end
end
function AddTag(uid, token, cid, name, time, mtime)
	local oMyFunc = GetDBMyFunc()
    local data = CheckToken(oMyFunc, uid, token)

    if data.code == RetCode.Success[1] then
		local guid = TextCode.Md5Encode(uid .. token .. cid .. name .. mtime)
    	data = _AddTag(oMyFunc, uid, token, guid, cid, name, time, mtime)
    end

	oMyFunc:freeInstance()
	return data
end

-- 删除一个标签
local function _DelTag(oMyFunc, uid, token, guid)
	local ret, err = DBSqlStmt.DelTag(oMyFunc, uid, token, guid)
	ret, err = DBSqlStmt.QueryTag(oMyFunc, uid, token, guid)
	if not ret then
		return {code = RetCode.Success[1], message = RetCode.Success[2], result = {guid = guid}}
	else
		return {code = RetCode.FailedDelTag[1], message = RetCode.FailedDelTag[2], result = ret}
	end
end
function DelTag(uid, token, guid)
	local oMyFunc = GetDBMyFunc()
    local data = CheckToken(oMyFunc, uid, token)

    if data.code == RetCode.Success[1] then
    	data = _DelTag(oMyFunc, uid, token, guid)
    end

	oMyFunc:freeInstance()
	return data
end

-- 修改标签名字
local function _UpdateTag(oMyFunc, uid, token, guid, name, time, mtime)
	local ret, err = DBSqlStmt.UpdateTag(oMyFunc, uid, token, guid, name, time, mtime)
	ret, err = DBSqlStmt.QueryTag(oMyFunc, uid, token, guid)
	if ret then
		return {code = RetCode.Success[1], message = RetCode.Success[2], result = ret}
	else
		return {code = RetCode.NotExistTag[1], message = RetCode.NotExistTag[2], result = {guid = guid, name = name}}
	end
end
function UpdateTag(uid, token, guid, name, time, mtime)
	local oMyFunc = GetDBMyFunc()
    local data = CheckToken(oMyFunc, uid, token)

    if data.code == RetCode.Success[1] then
    	data = _UpdateTag(oMyFunc, uid, token, guid, name, time, mtime)
    end

	oMyFunc:freeInstance()
	return data
end

-- 查询标签
local function _QueryTag(oMyFunc, uid, token, guid)
	local ret, err = DBSqlStmt.QueryTag(oMyFunc, uid, token, guid)
	if ret then
		return {code = RetCode.Success[1], message = RetCode.Success[2], result = ret}
	else
		return {code = RetCode.NotExistTag[1], message = RetCode.NotExistTag[2], result = {guid = guid}}
	end
end
function QueryTag(uid, token, guid)
	local oMyFunc = GetDBMyFunc()
    local data = CheckToken(oMyFunc, uid, token)

    if data.code == RetCode.Success[1] then
    	data = _QueryTag(oMyFunc, uid, token, guid)
    end

	oMyFunc:freeInstance()
	return data
end




--[[ ========================== 面料管理 ========================== ]]
local infoCols = " * "
local dataCols = " path "
-- 获取所有面料信息
function GetAllClothInfo (uid, token)
	local oMyFunc = GetDBMyFunc()
    local data = CheckToken(oMyFunc, uid, token)

    if data.code == RetCode.Success[1] then
		local ret, err = DBSqlStmt.GetAllClothInfo(oMyFunc, uid, token, infoCols)
		data = {code = RetCode.Success[1], message = RetCode.Success[2], result = ret or {}}
    end

	oMyFunc:freeInstance()
	return data
end

-- 添加一条面料信息
function AddCloth (uid, token, name, tag, mtime, time, scaleX, scaleY, cid, path, extra)
	local oMyFunc = GetDBMyFunc()
    local data = CheckToken(oMyFunc, uid, token)

    if data.code == RetCode.Success[1] then
		local guid = TextCode.Md5Encode(uid .. token .. name .. tag .. path .. mtime)
		if type(path) ~= 'string' or #path <= 0 then
			data = {code = RetCode.FailedAddCloth[1], message = RetCode.FailedAddCloth[2], result = ""}
		else
			local ret, err = DBSqlStmt.AddCloth(oMyFunc, uid, token, guid, name, tag, mtime, time, path, scaleX, scaleY, cid, extra)
			ret, err = DBSqlStmt.QueryCloth(oMyFunc, uid, token, guid, infoCols)
			if ret then
				data = {code = RetCode.Success[1], message = RetCode.Success[2], result = ret}
			else
				data = {code = RetCode.FailedAddCloth[1], message = RetCode.FailedAddCloth[2], result = ""}
			end
		end
    end

	oMyFunc:freeInstance()
	return data
end

-- 删除一条面料信息
local function _DelCloth (oMyFunc, uid, token, guid)
	local ret, err = DBSqlStmt.QueryCloth(oMyFunc, uid, token, guid, infoCols)
	if not ret then
		return {code = RetCode.Success[1], message = RetCode.Success[2], result = {guid = guid}}
	end
	local oldInfo = ret
	ret, err = DBSqlStmt.DelCloth(oMyFunc, uid, token, guid)
	ret, err = DBSqlStmt.QueryCloth(oMyFunc, uid, token, guid, infoCols)
	if not ret then
		return {code = RetCode.Success[1], message = RetCode.Success[2], result = oldInfo}
	else
		return {code = RetCode.FailedDelCloth[1], message = RetCode.FailedDelCloth[2], result = ret}
	end
end
function DelCloth (uid, token, guid)
	local oMyFunc = GetDBMyFunc()
    local data = CheckToken(oMyFunc, uid, token)

    if data.code == RetCode.Success[1] then
    	data = _DelCloth (oMyFunc, uid, token, guid)
    end

	oMyFunc:freeInstance()
	return data
end

-- 查询一条面料信息
local function _QueryCloth (oMyFunc, uid, token, guid, cols)
	cols = cols or infoCols
	local ret, err = DBSqlStmt.QueryCloth(oMyFunc, uid, token, guid, cols)
	if ret then
		return {code = RetCode.Success[1], message = RetCode.Success[2], result = ret}
	else
		return {code = RetCode.NotExistCloth[1], message = RetCode.NotExistCloth[2], result = {guid = guid}}
	end
end
function QueryCloth (uid, token, guid, cols)
	local oMyFunc = GetDBMyFunc()
    local data = CheckToken(oMyFunc, uid, token)

    if data.code == RetCode.Success[1] then
    	data = _QueryCloth (oMyFunc, uid, token, guid, cols)
    end

	oMyFunc:freeInstance()
	return data
end

-- 更新面料信息（名字、标签、缩放系数）
local function _UpdateCloth(oMyFunc, uid, token, guid, mtime, name, tag, scaleX, scaleY, extra, path)
	local ret, err = DBSqlStmt.UpdateCloth(oMyFunc, uid, token, guid, mtime, name, tag, scaleX, scaleY, extra, path)
	ret, err = DBSqlStmt.QueryCloth(oMyFunc, uid, token, guid, infoCols)
	if not ret then
		return {code = RetCode.NotExistCloth[1], message = RetCode.NotExistCloth[2], result = {guid = guid}}
	else
		return {code = RetCode.Success[1], message = RetCode.Success[2], result = ret}
	end
end
function UpdateCloth(uid, token, guid, mtime, name, tag, scaleX, scaleY, extra, path)
	local oMyFunc = GetDBMyFunc()
    local data = CheckToken(oMyFunc, uid, token)

    if data.code == RetCode.Success[1] then
    	data = _UpdateCloth(oMyFunc, uid, token, guid, mtime, name, tag, scaleX, scaleY, extra, path)
    end

	oMyFunc:freeInstance()
	return data
end

-- 获取用户所有面料信息的数量
function GetAllClothInfoCnt(uid, token)
	local oMyFunc = GetDBMyFunc()
    local data = CheckToken(oMyFunc, uid, token)

    if data.code == RetCode.Success[1] then
    	local ret, err = DBSqlStmt.GetAllClothInfoCnt(oMyFunc, uid, token)
    	if ret then
    		data = {code = RetCode.Success[1], message = RetCode.Success[2], result = ret.cnt}
    	else
    		data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}
    	end
    end

	oMyFunc:freeInstance()
	return data
end

-- 获取用户所有 sofa 模型的数量
function GetAllSofaModelCnt(uid, token)
	local oMyFunc = GetDBMyFunc()
    local data = CheckToken(oMyFunc, uid, token)

    if data.code == RetCode.Success[1] then
    	local ret, err = DBSqlStmt.GetAllSofaModelCnt(oMyFunc, uid, token)
    	if ret then
    		data = {code = RetCode.Success[1], message = RetCode.Success[2], result = ret.cnt}
    	else
    		data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}
    	end
    end

	oMyFunc:freeInstance()
	return data
end

-- 获取用户所有 sofa 配色的数量
function GetAllSofaColorlCnt(uid, token)
	local oMyFunc = GetDBMyFunc()
    local data = CheckToken(oMyFunc, uid, token)

    if data.code == RetCode.Success[1] then
    	local ret, err = DBSqlStmt.GetAllSofaColorlCnt(oMyFunc, uid, token)
    	if ret then
    		data = {code = RetCode.Success[1], message = RetCode.Success[2], result = ret.cnt}
    	else
    		data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}
    	end
    end

	oMyFunc:freeInstance()
	return data
end

--[[ ========================== 沙发模型管理 ========================== ]]
-- 增加一个 sofa 模型
function AddSofa(uid, token, cid, ntype, mtime, time, name, info_data, icon)
	local oMyFunc = GetDBMyFunc()
    local data = CheckToken(oMyFunc, uid, token)

    if data.code == RetCode.Success[1] then
		local guid = TextCode.Md5Encode(uid .. token .. cid .. name .. mtime)
		local ret, err = DBSqlStmt.AddSofa(oMyFunc, uid, token, guid, cid, ntype, mtime, time, name, info_data, icon)
		ret, err = DBSqlStmt.QuerySofa(oMyFunc, uid, token, guid)
		if ret then
			data = {code = RetCode.Success[1], message = RetCode.Success[2], result = ret}
		else
			data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = ""}
		end
    end

	oMyFunc:freeInstance()
	return data
end

-- 删除一个 sofa 模型
function DelSofa(uid, token, guid)
	local oMyFunc = GetDBMyFunc()
    local data = CheckToken(oMyFunc, uid, token)

    if data.code == RetCode.Success[1] then
		local ret, err = DBSqlStmt.DelSofa(oMyFunc, uid, token, guid)
		ret, err = DBSqlStmt.QuerySofa(oMyFunc, uid, token, guid)
		if not ret then
			data = {code = RetCode.Success[1], message = RetCode.Success[2], result = {guid = guid}}
		else
			data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = {guid = guid}}
		end
    end

	oMyFunc:freeInstance()
	return data
end

-- 修改一个 sofa 模型
function UpdateSofa(uid, token, guid, mtime, time, name, info_data, icon)
	local oMyFunc = GetDBMyFunc()
    local data = CheckToken(oMyFunc, uid, token)

    if data.code == RetCode.Success[1] then
		local ret, err = DBSqlStmt.UpdateSofa(oMyFunc, uid, token, guid, mtime, time, name, info_data, icon)
		ret, err = DBSqlStmt.QuerySofa(oMyFunc, uid, token, guid)
		if ret then
			data = {code = RetCode.Success[1], message = RetCode.Success[2], result = ret}
		else
			data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = ""}
		end
    end

	oMyFunc:freeInstance()
	return data
end


-- 查询一个 sofa 模型
function QuerySofa(uid, token, guid)
	local oMyFunc = GetDBMyFunc()
    local data = CheckToken(oMyFunc, uid, token)

    if data.code == RetCode.Success[1] then
		local ret, err = DBSqlStmt.QuerySofa(oMyFunc, uid, token, guid)
		if ret then
			data = {code = RetCode.Success[1], message = RetCode.Success[2], result = ret}
		else
			data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = ""}
		end
    end

	oMyFunc:freeInstance()
	return data
end

-- 查询用户所有 sofa 模型
function GetAllSofa(uid, token)
	local oMyFunc = GetDBMyFunc()
    local data = CheckToken(oMyFunc, uid, token)

    if data.code == RetCode.Success[1] then
		local ret, err = DBSqlStmt.GetAllSofa(oMyFunc, uid, token)
		data = {code = RetCode.Success[1], message = RetCode.Success[2], result = ret or {}}
    end

	oMyFunc:freeInstance()
	return data
end




--[[ ========================== 邮件 ========================== ]]
-- 获取用户所有notice邮件信息
function GetAllMail(uid,token,type,time)
	local oMyFunc = GetDBMyFunc()
    local data = CheckToken(oMyFunc, uid, token)
    --print("dddd:",uid,token,type,time)
    if data.code == RetCode.Success[1] then
		local ret, err = DBSqlStmt.GetAllMail(oMyFunc,uid, token,type,time)
	    data = {code = RetCode.Success[1], message = RetCode.Success[2], result = ret or {}}
    end

	oMyFunc:freeInstance()
	return data
end

-- 获取用户未读取邮件条数
function GetCountMail(uid,token,type,time)
	local oMyFunc = GetDBMyFunc()
    local data = CheckToken(oMyFunc, uid, token)
    --print("dddd:",uid,token,type,time)
    if data.code == RetCode.Success[1] then   	
		local ret, err = DBSqlStmt.GetCountMail(oMyFunc,uid, token,type,time)
		if not ret then
			data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}
		else
			data = {code = RetCode.Success[1], message = RetCode.Success[2], result = ret.number}
		end
    end

	oMyFunc:freeInstance()
	return data
end

-- 查询用户一条邮件信息
function GetOneMail(uid, token,guid)
	local oMyFunc = GetDBMyFunc()
	-- print("C2S.GetOneMailssss: ", uid, token,guid)
    local data = CheckToken(oMyFunc, uid, token)

    if data.code == RetCode.Success[1] then
		local ret, err = DBSqlStmt.GetOneMail(oMyFunc, uid, token,guid)
		data = {code = RetCode.Success[1], message = RetCode.Success[2], result = ret or {}}
    end

	oMyFunc:freeInstance()
	return data
end
-- 增加一条用户读取邮件的记录
function AddMailTag(mail_id,read_flag,read_time,uid,token)
	local oMyFunc = GetDBMyFunc()
    local data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}
	local ret,err= DBSqlStmt.QueryMailTag(oMyFunc,uid,token, mail_id)
	print("sss:",ret)
	if next(ret) == nil then		
	    local ret, err = DBSqlStmt.AddMailTag(oMyFunc, mail_id,read_flag,read_time,uid,token)
	    --print("sssadasda:",ret)
	     data = {code = RetCode.Success[1], message = RetCode.Success[2], result = ret or {}}	
	    else
	    	local read_flag= read_flag
	    	local read_time= read_time
	    	local guid= ret[1].guid	 	    
	        local ret, err = DBSqlStmt.UpdateMailTag(oMyFunc, read_flag,read_time,guid)
	        data = {code = RetCode.Success[1], message = RetCode.Success[2], result = ret or {}}			     
        end
	oMyFunc:freeInstance()
	return data
end
-- 增加一条邮件
function AddMail(type, gmName, send_uid,recv_uid,title,summary,content,attachment,send_time,expire_time)
	local oMyFunc = GetDBMyFunc()
	local data = {code = RetCode.Failed[1], message = RetCode.Failed[2], result = nil}			
	local ret, err = DBSqlStmt.AddMail(oMyFunc, type, gmName, send_uid,recv_uid,title,summary,content,attachment,send_time,expire_time)
	if ret then
	    data = {code = RetCode.Success[1], message = RetCode.Success[2], result = ret or {}}
	end
	oMyFunc:freeInstance()
	return data
end

-- 增加一条用户反馈邮件
function AddUserFeedBack(type,recv_uid,title,summary,content,attachment,send_time,uid,token)
	local oMyFunc = GetDBMyFunc()
	local data = CheckToken(oMyFunc, uid, token)
	if data.code == RetCode.Success[1] then
	local ret, err = DBSqlStmt.AddUserFeedBack(oMyFunc, type,recv_uid,title,summary,content,attachment,send_time,uid,token)
		data = {code = RetCode.Success[1], message = RetCode.Success[2], result = ret or {}}
    end
	oMyFunc:freeInstance()
	return data
end