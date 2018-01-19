-- 到DB服务端的协议
_G["S2DBS"] = {}


--[[ ========================== 短信验证码 ========================== ]]
-- 保存短信验证码
S2DBS.SaveIdtc = function (args, body, bodyFile)
	local phno, idtc, idtcTime = args.phno, args.idtc, tonumber(args.idtcTime)
	local intervalTime, extra = tonumber(args.intervalTime), args.extra
	return DBFunc.SaveIdtc(phno, idtc, idtcTime, extra, intervalTime)
end

-- 校验短信验证码
S2DBS.VerifyIdtc = function (args, body, bodyFile)
	local phno, idtc, currTime, expiredTime = args.phno, args.idtc, tonumber(args.currTime), tonumber(args.expiredTime)
	return DBFunc.VerifyIdtc(phno, idtc, currTime, expiredTime)
end

-- 使用短信验证码
S2DBS.UseIdtc = function (args, body, bodyFile)
	local phno, idtc, currTime, expiredTime = args.phno, args.idtc, args.currTime, args.expiredTime
	return DBFunc.UseIdtc(phno, idtc, currTime, expiredTime)
end

-- 查询短信验证码
S2DBS.QueryIdtc = function (args, body, bodyFile)
	local phno = args.phno
	return DBFunc.QueryIdtc(phno)
end


--[[ ========================== 账号管理 ========================== ]]
-- 账号注册
S2DBS.Register = function (args, body, bodyFile)
	local user, pass, rtype = args.user, args.pass, tonumber(args.type)
	local token, tokenTime = args.token or "", tonumber(args.tokenTime) or 0
	local location, userip, nick, head = args.location or "", args.userip or "", args.nick or "", args.head or ""
	local expire_time = tonumber(args.expire_time) or 0
	return DBFunc.Register(user, pass, rtype, token, tokenTime, nick, head, location, userip, expire_time)
end

-- 账号验证
S2DBS.Verify = function (args, body, bodyFile)
	local user, pass = args.user, args.pass
	local newToken, currTime, expiredTime = args.token, tonumber(args.currTime), tonumber(args.expiredTime)
	return DBFunc.Verify(user, pass, currTime, expiredTime, newToken)
end

-- 修改密码
S2DBS.ModifyPass = function (args, body, bodyFile)
	local user, pass = args.user, args.pass
	return DBFunc.ModifyPass(user, pass)
end

-- 更新头像和昵称
S2DBS.ModifyHeadAndNick = function (args, body, bodyFile)
	local uid, token = tonumber(args.uid), args.token
	local nick, head = args.nick, args.head
	local data = DBFunc.ModifyHeadAndNick(uid, token, nick, head)
	return data
end

-- 用 uid token 登录
S2DBS.Login = function (args, body, bodyFile)
	local uid, token = tonumber(args.uid), args.token
	local newToken, currTime, expiredTime = args.newToken, tonumber(args.currTime), tonumber(args.expiredTime)
	return DBFunc.Login(uid, token, currTime, expiredTime, newToken)
end

-- 更新 令牌
S2DBS.UpdateToken = function (args, body, bodyFile)
	local user, uid = args.user, tonumber(args.uid)
	local newToken, currTime, expiredTime = args.newToken, tonumber(args.currTime), tonumber(args.expiredTime)
	return DBFunc.UpdateToken(user, uid, currTime, expiredTime, newToken)
end

-- 查询用户数据
S2DBS.AccountQueryID = function (args, body, bodyFile)
	local uid, token = tonumber(args.uid), args.token
	return DBFunc.AccountQueryID(uid, token)
end

-- 使用user或者uid查询用户数据，若传入user，则以user为准。
S2DBS.QueryAccount = function (args, body, bodyFile)
	local user, uid = args.user, tonumber(args.uid)
	return DBFunc.QueryAccount(user, uid)
end

-- 查询符合条件用户数据
S2DBS.QueryUser = function (args, body, bodyFile)
	local uid, token = tonumber(args.uid), args.token
	local user, pass = args.user, args.pass
	local rtype, status = tonumber(args.type), tonumber(args.status)
	local owner_uid, nick = tonumber(args.owner_uid), args.nick
	return DBFunc.QueryUser(uid, token, user, pass, rtype, status, owner_uid, nick)
end




--[[ ========================== 企业账户&授权相关 ========================== ]]
-- 查询授权
S2DBS.QueryAccountAuth = function (args, body, bodyFile)
	local auth_code, auth_type, auth_status = args.auth_code, tonumber(args.auth_type), tonumber(args.auth_status)
	local sub_uid, com_uid, auth_uid = tonumber(args.sub_uid), tonumber(args.com_uid), tonumber(args.auth_uid)
	return DBFunc.QueryAccountAuth(auth_code, auth_type, auth_status, sub_uid, com_uid, auth_uid)
end

-- 个人账户创建企业账户
S2DBS.CreateComAccount = function (args, body, bodyFile)
	local uid, token, sub_user = tonumber(args.uid), args.token, args.sub_user
	local com_user, com_nick, com_head, com_expire_time = args.com_user, args.com_nick, args.com_head, tonumber(args.com_expire_time)
	local auth_code, grant_time, finish_time = args.auth_code, tonumber(args.grant_time), tonumber(args.finish_time) or 0
	return DBFunc.CreateComAccount(uid, token, sub_user, com_user, com_nick, com_head, com_expire_time, auth_code, grant_time, finish_time)
end

-- 企业账户增加一个成员授权邀请，只针对 企业成员(auth_type=0)。
S2DBS.AddAccountAuth = function (args, body, bodyFile)
	local uid, token = tonumber(args.uid), args.token
	local auth_code, auth_uid = args.auth_code, tonumber(args.auth_uid)
	local grant_time, finish_time = tonumber(args.grant_time), tonumber(args.finish_time) or 0
	return DBFunc.AddAccountAuth(uid, token, auth_code, grant_time, finish_time, auth_uid)
end

-- 企业账户删除一个成员授权，只针对 企业成员(auth_type=0)。
S2DBS.DelAccountAuth = function (args, body, bodyFile)
	local uid, token = tonumber(args.uid), args.token
	local auth_uid = tonumber(args.auth_uid)
	return DBFunc.DelAccountAuth(uid, token, auth_uid)
end

-- 企业账户拒绝授权申请，只针对 企业成员(auth_type=0)。
S2DBS.RefuseAccountApply = function (args, body, bodyFile)
	local uid, token = tonumber(args.uid), args.token
	local auth_code = args.auth_code
	return DBFunc.RefuseAccountApply(uid, token, auth_code)
end

-- 企业账户接受授权申请，只针对 企业成员(auth_type=0)。
S2DBS.AcceptAccountApply = function (args, body, bodyFile)
	local uid, token = tonumber(args.uid), args.token
	local auth_code, sub_user, finish_time = args.auth_code, args.sub_user, tonumber(args.finish_time)
	return DBFunc.AcceptAccountApply(uid, token, auth_code, sub_user, finish_time)
end

-- 个人账户申请授权，只针对 企业成员(auth_type=0)。
S2DBS.AddAccountApply = function (args, body, bodyFile)
	local uid, token = tonumber(args.uid), args.token
	local auth_code, com_uid = args.auth_code, tonumber(args.com_uid)
	local grant_time, finish_time = tonumber(args.grant_time), tonumber(args.finish_time)
	return DBFunc.AddAccountApply(uid, token, auth_code, grant_time, finish_time, com_uid)
end

-- 个人账户拒绝授权，只针对 企业成员(auth_type=0)。
S2DBS.RefuseAccountAuth = function (args, body, bodyFile)
	local uid, token = tonumber(args.uid), args.token
	local auth_code = args.auth_code
	return DBFunc.RefuseAccountAuth(uid, token, auth_code)
end

-- 个人账户接受授权，只针对 企业成员(auth_type=0)。
S2DBS.AcceptAccountAuth = function (args, body, bodyFile)
	local uid, token = tonumber(args.uid), args.token
	local auth_code, sub_user, finish_time = args.auth_code, args.sub_user, tonumber(args.finish_time)
	return DBFunc.AcceptAccountAuth(uid, token, auth_code, sub_user, finish_time)
end

-- 企业账户转让，老板权限的转移
S2DBS.TransferAccountAuth = function (args, body, bodyFile)
	local uid, token = tonumber(args.uid), args.token
	local auth_uid = tonumber(args.auth_uid)
	return DBFunc.TransferAccountAuth(uid, token, auth_uid)
end

-- 企业账户解散授权(Dismiss)。
S2DBS.DismissAccountAuth = function (args, body, bodyFile)
	local uid, token = tonumber(args.uid), args.token
	return DBFunc.DismissAccountAuth(uid, token)
end

-- 企业账户获取所有成员信息
S2DBS.GetAllAccountAuth = function (args, body, bodyFile)
	local uid, token = tonumber(args.uid), args.token
	return DBFunc.GetAllAccountAuth(uid, token)
end

-- 个人账户（企业主）将自己的面料、沙发数据转移到企业账户中。
S2DBS.UserDataToComData = function (args, body, bodyFile)
	local uid, token, com_uid = tonumber(args.uid), args.token, tonumber(args.com_uid)
	return DBFunc.UserDataToComData(uid, token, com_uid)
end

-- 企业账户将自己的面料、沙发数据转移到企业主（个人账户）中。
S2DBS.ComDataToUserData = function (args, body, bodyFile)
	local uid, token = tonumber(args.uid), args.token
	return DBFunc.ComDataToUserData(uid, token)
end




--[[ ========================== 会员、支付相关 ========================== ]]
-- 新增订单
S2DBS.AddTrade = function (args, body, bodyFile)
	local uid, token = tonumber(args.uid), args.token
	local trade_no, pid, ptype, extra = args.trade_no, args.pid, tonumber(args.type), args.extra
	local amount, add_time, cre_time = tonumber(args.amount), tonumber(args.add_time), tonumber(args.cre_time)
	return DBFunc.AddTrade(uid, token, trade_no, ptype, pid, amount, add_time, cre_time, extra)
end

-- 完成订单
S2DBS.FinishTrade = function (args, body, bodyFile)
	local trade_no, done_time = args.trade_no, tonumber(args.done_time)
	return DBFunc.FinishTrade(trade_no, done_time)
end

-- 查询订单
S2DBS.QueryTrade = function (args, body, bodyFile)
	local uid, token = tonumber(args.uid), args.token
	local trade_no = args.trade_no
	return DBFunc.QueryTrade(uid, token, trade_no)
end




--[[ ========================== 面料标签管理 ========================== ]]
-- 获取用户所有标签信息
S2DBS.GetAllTag = function (args, body, bodyFile)
	local uid, token = tonumber(args.uid), args.token
	return DBFunc.GetAllTag(uid, token)
end

-- 增加一个 tag 标签
S2DBS.AddTag = function (args, body, bodyFile)
	local uid, token = tonumber(args.uid), args.token
	local name, mtime = args.name, tonumber(args.mtime)
	local cid, time = args.cid, args.time
	return DBFunc.AddTag(uid, token, cid, name, time, mtime)
end

-- 删除一个标签
S2DBS.DelTag = function (args, body, bodyFile)
	local uid, token = tonumber(args.uid), args.token
	local guid = args.guid
	return DBFunc.DelTag(uid, token, guid)
end

-- 查询一个标签
S2DBS.QueryTag = function (args, body, bodyFile)
	local uid, token = tonumber(args.uid), args.token
	local guid = args.guid
	return DBFunc.QueryTag(uid, token, guid)
end

-- 修改标签名字
S2DBS.UpdateTag = function (args, body, bodyFile)
	local uid, token = tonumber(args.uid), args.token
	local guid, name, time, mtime = args.guid, args.name, args.time, tonumber(args.mtime)
	return DBFunc.UpdateTag(uid, token, guid, name, time, mtime)
end




--[[ ========================== 面料管理 ========================== ]]
-- 获取所有面料信息
S2DBS.GetAllClothInfo = function (args, body, bodyFile)
	local uid, token = tonumber(args.uid), args.token
	return DBFunc.GetAllClothInfo(uid, token)
end

--[[
-- 下载面料图片数据
S2DBS.DownloadCloth = function (args, body, bodyFile)
	local uid, token = tonumber(args.uid), args.token
	local guid = args.guid
	return DBFunc.DownloadCloth(uid, token, guid)
end
--]]

-- 添加一条面料信息
S2DBS.AddCloth = function (args, body, bodyFile)
	local uid, token = tonumber(args.uid), args.token
	local name, tag, mtime = args.name, args.tag, tonumber(args.mtime)
	local time, scaleX, scaleY = args.time, tonumber(args.scaleX), tonumber(args.scaleY)
	local cid, extra, path = args.cid, args.extra, args.path
	return DBFunc.AddCloth(uid, token, name, tag, mtime, time, scaleX, scaleY, cid, path, extra)
end

-- 删除一条面料信息
S2DBS.DelCloth = function (args, body, bodyFile)
	local uid, token = tonumber(args.uid), args.token
	local guid = args.guid
	return DBFunc.DelCloth(uid, token, guid)
end

-- 查询一条面料信息
S2DBS.QueryCloth = function (args, body, bodyFile)
	local uid, token = tonumber(args.uid), args.token
	local guid = args.guid
	return DBFunc.QueryCloth (uid, token, guid)
end

-- 更新面料信息（名字、标签、缩放系数）
S2DBS.UpdateCloth = function (args, body, bodyFile)
	local uid, token = tonumber(args.uid), args.token
	local guid, mtime = args.guid, tonumber(args.mtime)
	local name, tag = args.name, args.tag
	local scaleX, scaleY = tonumber(args.scaleX), tonumber(args.scaleY)
	local extra, path = args.extra, args.path
	return DBFunc.UpdateCloth(uid, token, guid, mtime, name, tag, scaleX, scaleY, extra, path)
end




-- 获取用户所有面料信息的数量
S2DBS.GetAllClothInfoCnt = function (args, body, bodyFile)
	local uid, token = tonumber(args.uid), args.token
	return DBFunc.GetAllClothInfoCnt(uid, token)
end

-- 获取用户所有 sofa 模型的数量
S2DBS.GetAllSofaModelCnt = function (args, body, bodyFile)
	local uid, token = tonumber(args.uid), args.token
	return DBFunc.GetAllSofaModelCnt(uid, token)
end

-- 获取用户所有 sofa 配色的数量
S2DBS.GetAllSofaColorlCnt = function (args, body, bodyFile)
	local uid, token = tonumber(args.uid), args.token
	return DBFunc.GetAllSofaColorlCnt(uid, token)
end



--[[ ========================== 沙发模型管理 ========================== ]]
-- 增加一个 sofa 模型
S2DBS.AddSofa = function (args, body, bodyFile)
	local uid, token = tonumber(args.uid), args.token
	if not body then
        local fh, err = io.open(bodyFile, "r")
        assert(fh, err)
        fh:seek("set")
        body = fh:read("*a")
        fh:close()
	end
	local info = TextCode.JsonDecode(body)
--print("S2DBS.AddSofa: ", info)
	return DBFunc.AddSofa(uid, token, info.cid, tonumber(info.type), tonumber(info.mtime), info.time, info.name, info.data, info.icon)
end

-- 删除一个 sofa 模型
S2DBS.DelSofa = function (args, body, bodyFile)
	local uid, token, guid = tonumber(args.uid), args.token, args.guid
--print("S2DBS.DelSofa: ", uid, token, guid)
	return DBFunc.DelSofa(uid, token, guid)
end

-- 修改一个 sofa 模型
S2DBS.UpdateSofa = function (args, body, bodyFile)
	local uid, token = tonumber(args.uid), args.token
	if not body then
        local fh, err = io.open(bodyFile, "r")
        if fh then
	        fh:seek("set")
	        body = fh:read("*a")
	        fh:close()
        end
	end
	local info = TextCode.JsonDecode(body)
--print("S2DBS.UpdateSofa: ", info)
	return DBFunc.UpdateSofa(uid, token, info.guid, tonumber(info.mtime), info.time, info.name, info.data, info.icon)
end

-- 查询一个 sofa 模型
S2DBS.QuerySofa = function (args, body, bodyFile)
	local uid, token, guid = tonumber(args.uid), args.token, args.guid
--print("S2DBS.QuerySofa: ", uid, token, guid)
	return DBFunc.QuerySofa(uid, token, guid)
end

-- 查询用户所有 sofa 模型
S2DBS.GetAllSofa = function (args, body, bodyFile)
	local uid, token = tonumber(args.uid), args.token
--print("S2DBS.GetAllSofa: ", uid, token)
	return DBFunc.GetAllSofa(uid, token)
end




--[[ ========================== 邮件========================== ]]
-- 查询用户所有notice邮件信息
S2DBS.GetAllMail = function (args, body, bodyFile)
	local uid, token,type,time = tonumber(args.uid), args.token,tonumber(args.type),tonumber(args.time)
	--print("S2DBS.GetAllMail: ",args) 
	return DBFunc.GetAllMail(uid, token,type,time)
end
-- 查询用户已读取邮件条数
S2DBS.GetCountMail = function (args, body, bodyFile)
	local uid, token,type,time = tonumber(args.uid), args.token,tonumber(args.type),tonumber(args.time)
	--print("S2DBS.GetAllMail: ",args) 
	return DBFunc.GetCountMail(uid, token,type,time)
end
-- 查询用户一条邮件信息
S2DBS.GetOneMail = function (args, body, bodyFile)
	local uid, token,guid = tonumber(args.uid), args.token,args.guid
 --print("C2S.GetOneMaildddd: ", uid, token,guid)
	return DBFunc.GetOneMail(uid, token,guid)
end
-- 增加一个用户读取邮件的记录
S2DBS.AddMailTag = function (args, body, bodyFile)
    local uid,token = tonumber(args.uid),args.token
	local read_flag = tonumber(args.read_flag)
	local mail_id = tonumber(args.mail_id)
	local read_time = tonumber(args.read_time)
    print("S2DBS.AddMailTagssss: ",args)
	return DBFunc.AddMailTag(mail_id,read_flag,read_time,uid,token)
end
-- 增加一条邮件
S2DBS.AddMail = function (args, body, bodyFile)
    local type, gmName, send_uid,recv_uid= tonumber(args.type),args.gmName,tonumber(args.send_uid),tonumber(args.recv_uid)
	local title,summary,content,attachment,send_time,expire_time = args.title,args.summary,args.content,args.attachment,tonumber(args.send_time),tonumber(args.expire_time)
   -- print("S2DBS.AddMailsdasdassss: ",args)
	return DBFunc.AddMail(type, gmName, send_uid,recv_uid,title,summary,content,attachment,send_time,expire_time)
end
-- 增加一条用户反馈邮件
S2DBS.AddUserFeedBack = function (args, body, bodyFile)
    local type, uid,recv_uid,token= tonumber(args.type),tonumber(args.uid),tonumber(args.recv_uid),args.token
	local title,summary,content,attachment,send_time = args.title,args.summary,args.content,args.attachment,tonumber(args.send_time)
   --print("S2DBS.AddMailsdasdassss: ",args)
	return DBFunc.AddUserFeedBack(type,recv_uid,title,summary,content,attachment,send_time,uid,token)
end