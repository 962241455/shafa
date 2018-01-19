-- 客户端到服务端的协议
_G["C2S"] = {}

-- =============================== 版本号 ===============================
-- 获取服务器版本号
C2S.ServerVersion = function (oRole, args, body, bodyFile)
	assert(oRole:IsClass(CRole), "oRole is not validate !")
	return VersionMgr.GetServerVersion()
end





-- =============================== 账号系统相关 ===============================
-- 游客账号验证（自动注册）
C2S.GuestVerify = function (oRole, args, body, bodyFile)
	assert(oRole:IsClass(CRole), "oRole is not validate !")
	local user, pass, nick = args.user, args.pass, args.nick
	return AccountMgr.GuestVerify(oRole, user, pass, nick)
end

-- 账号注册
C2S.Register = function (oRole, args, body, bodyFile)
	assert(oRole:IsClass(CRole), "oRole is not validate !")
	local user, pass, nick, idtc = args.user, args.pass, args.nick, args.idtc
	return AccountMgr.Register(oRole, user, pass, nick, idtc)
end

-- 账号验证
C2S.Verify = function (oRole, args, body, bodyFile)
	assert(oRole:IsClass(CRole), "oRole is not validate !")
	local user, pass = args.user, args.pass
	return AccountMgr.Verify(oRole, user, pass)
end

-- 登陆(获取用户数据)
C2S.Login = function (oRole, args, body, bodyFile)
	assert(oRole:IsClass(CRole), "oRole is not validate !")
	return AccountMgr.Login(oRole)
end

-- 心跳
C2S.Heartbeat = function (oRole, args, body, bodyFile)
	assert(oRole:IsClass(CRole), "oRole is not validate !")
	return AccountMgr.Heartbeat(oRole)
end

-- 丢失了密码
C2S.LosePass = function (oRole, args, body, bodyFile)
	assert(oRole:IsClass(CRole), "oRole is not validate !")
	local user, pass, idtc = args.user, args.pass, args.idtc
	return AccountMgr.LosePassWord(oRole, user, pass, idtc)
end

-- 改密码
C2S.ModifyPass = function (oRole, args, body, bodyFile)
	assert(oRole:IsClass(CRole), "oRole is not validate !")
	local user, pass = args.user, args.pass
	return AccountMgr.ModifyPassWord(oRole, user, pass)
end

-- 获取手机验证码 IdentifyCode
C2S.GetIdtc = function (oRole, args, body, bodyFile)
	assert(oRole:IsClass(CRole), "oRole is not validate !")
	return AccountMgr.GetIdtc(oRole, args.user)
end

-- 获取手机验证码 IdentifyCode，已经注册过的账号才能获取
C2S.GetIdtcWithRegister = function (oRole, args, body, bodyFile)
	assert(oRole:IsClass(CRole), "oRole is not validate !")
	return AccountMgr.GetIdtcWithRegister(oRole, args.user)
end

-- 获取手机验证码 IdentifyCode，没有注册过的账号才能获取
C2S.GetIdtcWithUnRegister = function (oRole, args, body, bodyFile)
	assert(oRole:IsClass(CRole), "oRole is not validate !")
	return AccountMgr.GetIdtcWithUnRegister(oRole, args.user)
end

-- 校验短信验证码
C2S.CheckIdtc = function (oRole, args, body, bodyFile)
	assert(oRole:IsClass(CRole), "oRole is not validate !")
	return AccountMgr.CheckIdtc(oRole, args.user, args.idtc)
end

-- 登录企业（子）账户
C2S.LoginCom = function (oRole, args, body, bodyFile)
	assert(oRole:IsClass(CRole), "oRole is not validate !")
	local com_uid = tonumber(args.com_uid)
	return AccountMgr.LoginCom(oRole, com_uid)
end

-- 获取头像
C2S.GetHeadImg = function (oRole, args, body, bodyFile)
	assert(oRole:IsClass(CRole), "oRole is not validate !")
	local md5 = args.md5
	return AccountMgr.GetHeadImg(oRole, md5)
end

-- 更新头像和昵称
C2S.ModifyHeadAndNick = function (oRole, args, body, bodyFile)
	assert(oRole:IsClass(CRole), "oRole is not validate !")
	local nick, headImg = args.nick, nil
	if (not body) and bodyFile then
        local fh, err = io.open(bodyFile, "rb")
        assert(fh, err)
        fh:seek("set")
        body = fh:read("*a")
        fh:close()
        --print("C2S.ModifyHeadAndNick: " .. bodyFile)
	end
	headImg = body
	return AccountMgr.ModifyHeadAndNick(oRole, nick, headImg)
end

-- 查询企业
C2S.FindCom = function (oRole, args, body, bodyFile)
	assert(oRole:IsClass(CRole), "oRole is not validate !")
	local name, phno, com_uid = args.name, args.phno, tonumber(args.com_uid)
	return AccountMgr.FindCom(oRole, phno, com_uid, name)
end




--[[ ========================== 企业账户&授权相关 ========================== ]]
-- 个人账户创建企业账户
C2S.CreateComAccount = function (oRole, args, body, bodyFile)
	assert(oRole:IsClass(CRole), "oRole is not validate !")
	local name = args.name
	if not body and bodyFile then
        local fh, err = io.open(bodyFile, "rb")
        assert(fh, err)
        fh:seek("set")
        body = fh:read("*a")
        fh:close()
        --print("C2S.CreateComAccount: " .. bodyFile)
	end
	local logo = body
	return AccountAuthMgr.CreateComAccount(oRole, name, logo)
end

--[[
-- 个人账户拒绝授权，只针对 企业成员(auth_type=0)。
C2S.RefuseAccountAuth = function (oRole, args, body, bodyFile)
	assert(oRole:IsClass(CRole), "oRole is not validate !")
	local auth_code = args.auth_code
	return AccountAuthMgr.RefuseAccountAuth(oRole, auth_code)
end

-- 个人账户接受授权，只针对 企业成员(auth_type=0)。
C2S.AcceptAccountAuth = function (oRole, args, body, bodyFile)
	assert(oRole:IsClass(CRole), "oRole is not validate !")
	local auth_code = args.auth_code
	return AccountAuthMgr.AcceptAccountAuth(oRole, auth_code)
end
--]]

-- 个人账户获取所有有效授权信息
C2S.GetMyAccountAuth = function (oRole, args, body, bodyFile)
	assert(oRole:IsClass(CRole), "oRole is not validate !")
	return AccountAuthMgr.GetMyAccountAuth(oRole)
end

-- 企业账户获取所有成员信息
C2S.GetAllAccountAuth = function (oRole, args, body, bodyFile)
	assert(oRole:IsClass(CRole), "oRole is not validate !")
	return AccountAuthMgr.GetAllAccountAuth(oRole)
end

--[[
-- 企业账户增加一个成员授权邀请，只针对 企业成员(auth_type=0)。
C2S.AddAccountAuth = function (oRole, args, body, bodyFile)
	assert(oRole:IsClass(CRole), "oRole is not validate !")
	local auth_uid = tonumber(args.auth_uid)
	return AccountAuthMgr.AddAccountAuth(oRole, auth_uid)
end

-- 企业账户增加一个成员授权邀请，只针对 企业成员(auth_type=0)。
C2S.AddAccountAuthByUser = function (oRole, args, body, bodyFile)
	assert(oRole:IsClass(CRole), "oRole is not validate !")
	local auth_user = args.auth_user
	return AccountAuthMgr.AddAccountAuthByUser(oRole, auth_user)
end
--]]

-- 企业账户删除一个成员授权，只针对 企业成员(auth_type=0)。
C2S.DelAccountAuth = function (oRole, args, body, bodyFile)
	assert(oRole:IsClass(CRole), "oRole is not validate !")
	local auth_uid = tonumber(args.auth_uid)
	return AccountAuthMgr.DelAccountAuth(oRole, auth_uid)
end

-- 企业子账户主动解除授权
C2S.QuitAccountAuth = function (oRole, args, body, bodyFile)
	assert(oRole:IsClass(CRole), "oRole is not validate !")
	return AccountAuthMgr.QuitAccountAuth(oRole)
end

-- 企业账户转让，老板权限的转移
C2S.TransferAccountAuth = function (oRole, args, body, bodyFile)
	assert(oRole:IsClass(CRole), "oRole is not validate !")
	local auth_uid = tonumber(args.auth_uid)
	local pass = tostring(args.pass)
	return AccountAuthMgr.TransferAccountAuth(oRole, pass, auth_uid)
end

-- 企业账户解散授权(Dismiss)。
C2S.DismissAccountAuth = function (oRole, args, body, bodyFile)
	assert(oRole:IsClass(CRole), "oRole is not validate !")
	local pass = tostring(args.pass)
	return AccountAuthMgr.DismissAccountAuth(oRole, pass)
end

-- 企业账户拒绝授权申请，只针对 企业成员(auth_type=0)。
C2S.RefuseAccountApply = function (oRole, args, body, bodyFile)
	assert(oRole:IsClass(CRole), "oRole is not validate !")
	local auth_code = args.auth_code
	return AccountAuthMgr.RefuseAccountApply(oRole, auth_code)
end

-- 企业账户接受授权申请，只针对 企业成员(auth_type=0)。
C2S.AcceptAccountApply = function (oRole, args, body, bodyFile)
	assert(oRole:IsClass(CRole), "oRole is not validate !")
	local auth_code = args.auth_code
	return AccountAuthMgr.AcceptAccountApply(oRole, auth_code)
end

-- 个人账户申请授权，只针对 企业成员(auth_type=0)。
C2S.AddAccountApply = function (oRole, args, body, bodyFile)
	assert(oRole:IsClass(CRole), "oRole is not validate !")
	local com_uid = tonumber(args.com_uid)
	return AccountAuthMgr.AddAccountApply(oRole, com_uid)
end

-- 个人账户（企业主）将自己的面料、沙发数据转移到企业账户中。
C2S.UserDataToComData = function (oRole, args, body, bodyFile)
	assert(oRole:IsClass(CRole), "oRole is not validate !")
	local com_uid = tonumber(args.com_uid)
	return AccountAuthMgr.UserDataToComData(oRole, com_uid)
end

-- 企业账户将自己的面料、沙发数据转移到企业主（个人账户）中。
C2S.ComDataToUserData = function (oRole, args, body, bodyFile)
	assert(oRole:IsClass(CRole), "oRole is not validate !")
	return AccountAuthMgr.ComDataToUserData(oRole)
end





-- =============================== 支付系统相关 ===============================
-- 同步支付配置
C2S.SyncPayCfg = function (oRole, args, body, bodyFile)
	assert(oRole:IsClass(CRole), "oRole is not validate !")
	return PayMgr.SyncPayCfg(oRole)
end

-- 支付，生成订单
C2S.Pay = function (oRole, args, body, bodyFile)
	assert(oRole:IsClass(CRole), "oRole is not validate !")
	local pid, payway, paymod = args.pid, args.payway, tonumber(args.paymod)
	return PayMgr.Pay(oRole, pid, payway, paymod)
end

-- 查询订单
C2S.QueryTrade = function (oRole, args, body, bodyFile)
	assert(oRole:IsClass(CRole), "oRole is not validate !")
	local trade_no = args.tradeno
	return PayMgr.QueryTrade(oRole, trade_no)
end




-- =============================== 面料系统相关 ===============================
-- 获取用户所有标签信息
C2S.GetAllTag = function (oRole, args, body, bodyFile)
	assert(oRole:IsClass(CRole), "oRole is not validate !")
	return ClothMgr.GetAllTag(oRole)
end

-- 增加一个 tag 标签
C2S.AddTag = function (oRole, args, body, bodyFile)
	assert(oRole:IsClass(CRole), "oRole is not validate !")
	local mtime, name = tonumber(args.mtime), args.name
	local cid, time = args.cid, args.time
	return ClothMgr.AddTag(oRole, cid, name, time, mtime)
end

-- 删除一个标签
C2S.DelTag = function (oRole, args, body, bodyFile)
	assert(oRole:IsClass(CRole), "oRole is not validate !")
	return ClothMgr.DelTag(oRole, tostring(args.guid))
end

-- 修改标签名字
C2S.UpdateTag = function (oRole, args, body, bodyFile)
	assert(oRole:IsClass(CRole), "oRole is not validate !")
	local guid, name, time, mtime = args.guid, args.name, args.time, tonumber(args.mtime)
	return ClothMgr.UpdateTag(oRole, guid, name, time, mtime)
end

-- 查询一个标签
C2S.QueryTag = function (oRole, args, body, bodyFile)
	assert(oRole:IsClass(CRole), "oRole is not validate !")
	return ClothMgr.QueryTag(oRole, tostring(args.guid))
end


-- 获取用户所有面料信息
C2S.GetAllClothInfo = function (oRole, args, body, bodyFile)
	assert(oRole:IsClass(CRole), "oRole is not validate !")
	return ClothMgr.GetAllClothInfo(oRole)
end

-- 下载面料
C2S.DownloadCloth = function (oRole, args, body, bodyFile)
	assert(oRole:IsClass(CRole), "oRole is not validate !")
	return ClothMgr.DownloadCloth(oRole, tostring(args.guid))
end

-- 添加一条面料信息
C2S.AddCloth = function (oRole, args, body, bodyFile)
	assert(oRole:IsClass(CRole), "oRole is not validate !")
	local name = args.name
	local tag = args.tag
	local mtime = args.mtime
	local time = args.time
	local scaleX = args.scaleX
	local scaleY = args.scaleY
	local cid, extra = args.cid, args.extra
	if not body then
        local fh, err = io.open(bodyFile, "rb")
        assert(fh, err)
        fh:seek("set")
        body = fh:read("*a")
        fh:close()
        --print("C2S.AddCloth: " .. bodyFile)
	end
	local picData = body
	return ClothMgr.AddCloth (oRole, name, tag, mtime, time, scaleX, scaleY, cid, extra, picData)
end

-- 删除一条面料信息
C2S.DelCloth = function (oRole, args, body, bodyFile)
	assert(oRole:IsClass(CRole), "oRole is not validate !")
	return ClothMgr.DelCloth(oRole, tostring(args.guid))
end

-- 查询一条面料信息
C2S.QueryCloth = function (oRole, args, body, bodyFile)
	assert(oRole:IsClass(CRole), "oRole is not validate !")
	return ClothMgr.QueryCloth(oRole, tostring(args.guid))
end

-- 更新面料信息（名字、标签、缩放系数）
C2S.UpdateCloth = function (oRole, args, body, bodyFile)
	assert(oRole:IsClass(CRole), "oRole is not validate !")
	local guid = args.guid
	local mtime = tonumber(args.mtime) or os.time()
	local name = args.name
	local tag = args.tag
	local scaleX = tonumber(args.scaleX)
	local scaleY = tonumber(args.scaleY)
	local extra = args.extra
	if bodyFile and not body then
        local fh, err = io.open(bodyFile, "rb")
        assert(fh, err)
        fh:seek("set")
        body = fh:read("*a")
        fh:close()
        --print("C2S.UpdateCloth: " .. bodyFile)
	end
	local picData = body
	return ClothMgr.UpdateCloth(oRole, guid, mtime, name, tag, scaleX, scaleY, extra, picData)
end




--[[ ========================== 沙发模型管理 ========================== ]]
-- 增加一个 sofa 模型
C2S.AddSofa = function (oRole, args, body, bodyFile)
	assert(oRole:IsClass(CRole), "oRole is not validate !")
	if not body then
        local fh, err = io.open(bodyFile, "r")
        assert(fh, err)
        fh:seek("set")
        body = fh:read("*a")
        fh:close()
	end
	local info = TextCode.JsonDecode(body)
	return SofaMgr.AddSofa(oRole, info.cid, tonumber(info.type), tonumber(info.mtime), info.time, info.name, info.data, info.icon)
end

-- 删除一个 sofa 模型
C2S.DelSofa = function (oRole, args, body, bodyFile)
	assert(oRole:IsClass(CRole), "oRole is not validate !")
	return SofaMgr.DelSofa(oRole, args.guid)
end

-- 修改一个 sofa 模型
C2S.UpdateSofa = function (oRole, args, body, bodyFile)
	assert(oRole:IsClass(CRole), "oRole is not validate !")
	if not body then
        local fh, err = io.open(bodyFile, "r")
        if fh then
	        fh:seek("set")
	        body = fh:read("*a")
	        fh:close()
        end
	end
	local info = TextCode.JsonDecode(body)
	return SofaMgr.UpdateSofa(oRole, info.guid, tonumber(info.mtime), info.time, info.name, info.data, info.icon)
end

-- 查询一个 sofa 模型
C2S.QuerySofa = function (oRole, args, body, bodyFile)
	assert(oRole:IsClass(CRole), "oRole is not validate !")
	return SofaMgr.QuerySofa(oRole, args.guid)
end

-- 查询用户所有 sofa 模型
C2S.GetAllSofa = function (oRole, args, body, bodyFile)
	assert(oRole:IsClass(CRole), "oRole is not validate !")
	return SofaMgr.GetAllSofa(oRole)
end




--[[ ========================== 分享管理 ========================== ]]
-- 分享
C2S.Share = function (oRole, args, body, bodyFile)
	assert(oRole:IsClass(CRole), "oRole is not validate !")
	return ShareMgr.Share(oRole, args.info)
end




--[[ ========================== 邮件管理 ========================== ]]
--获取系统通知邮件Url
C2S.GetNoticeUrl = function (oRole, args, body, bodyFile)
    assert(oRole:IsClass(CRole), "oRole is not validate !")
    return MailMgr.GetNoticeUrl(oRole)
end

--获取某个用户未读取系统邮件条数
C2S.GetSysNoticeNotReadCount = function (oRole, args, body, bodyFile)
    assert(oRole:IsClass(CRole), "oRole is not validate !")
    return MailMgr.GetSysNoticeNotReadCount(oRole)    
end

--获取某个用户所有的系统通知
C2S.GetSysNotice = function (oRole, args, body, bodyFile)
    assert(oRole:IsClass(CRole), "oRole is not validate !")
    return MailMgr.GetSysNotice(oRole)    
end

--获取某个用户所有的系统邮件
C2S.GetSysMail = function (oRole, args, body, bodyFile)
    assert(oRole:IsClass(CRole), "oRole is not validate !")
    return MailMgr.GetSysMail(oRole)    
end

--获取某个用户所有的充值邮件
C2S.GetPayMail = function (oRole, args, body, bodyFile)
    assert(oRole:IsClass(CRole), "oRole is not validate !")
    return MailMgr.GetPayMail(oRole)    
end

--获取用户的一条邮件
C2S.GetOneMail = function (oRole, args, body, bodyFile)
    assert(oRole:IsClass(CRole), "oRole is not validate !")
    return MailMgr.GetOneMail(oRole, args.guid)
end

--用户读取邮件的记录
C2S.ReadMailTag = function (oRole, args, body, bodyFile)    
    assert(oRole:IsClass(CRole), "oRole is not validate !")
    return MailMgr.ReadMailTag(oRole, args.mail_id)
end

--用户反馈邮件
C2S.AddUserFeedBack = function (oRole, args, body, bodyFile)    
    assert(oRole:IsClass(CRole), "oRole is not validate !")
	local title,summary,content,attachment = args.title,args.summary,args.content,args.attachment
    --print("C2S.AddUserFeedBack: ",args, send_uid,recv_uid,title,summary,content,attachment)
    return MailMgr.AddUserFeedBack(oRole,title,summary,content,attachment)
end
