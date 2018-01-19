-- MailMgr 系统通知管理
module("MailMgr", package.seeall)

-- 获取用户的所有的邮件
function GetAllMail(type,uid, token)	
    local args = {}
	args.action = "GetAllMail"
	args.type=type
	args.uid = uid
	args.token = token
	args.time= os.time()
	return ReqEx.ReqDBS(args, nil)
end

--获取系统通知用户已读取邮件条数
function GetCountMail(type,uid, token)	
    local args = {}
	args.action = "GetCountMail"
	args.type=type
	args.uid = uid
	args.token = token
	args.time= os.time()
	return ReqEx.ReqDBS(args, nil)
end

-- 增加一条邮件
function AddMail(type,gmName, send_uid,recv_uid,title,summary,content,attachment,expire_time)
 if not gmName then
    	gmName=''
    end	
    local args = {}
   
    args.type=type
	args.action = "AddMail"
	args.gmName = gmName
	args.send_uid= send_uid
	args.recv_uid=recv_uid
	args.title=title
	args.summary=summary
	args.content=content
	args.attachment=attachment
	args.send_time=os.time()
	args.expire_time=0
	if LuaEx.IsNumber(expire_time) then
		args.expire_time=expire_time+args.send_time
     else
     	if _G["ServCfg"]['mail_expire_time'] ~=0 then
		   args.expire_time=args.send_time+_G["ServCfg"]['mail_expire_time']
		end
     end
     --print("aaaaaa:",args)
	local data = ReqEx.ReqDBS(args, nil)
	return data
end

-- 系统通知邮件协议
function GetNoticeUrl(oRole)
	assert(oRole:IsClass(CRole) and oRole.m_Init, "oRole is not validate !")
	local uid, token = oRole.m_uid, oRole.m_token

	local url = string.format(_G['ServCfg']['web_page_url'].."index.php?r=site/mail")
	local data = {code = RetCode.Success[1], message = RetCode.Success[2], result = url}
	return data
end

--获取系统通知用户未读取邮件条数
function GetSysNoticeNotReadCount(oRole)
	assert(oRole:IsClass(CRole) and oRole.m_Init, "oRole is not validate !")
	local uid, token = oRole.m_uid, oRole.m_token

	return GetCountMail(RoleDef.MailType.SysNotice, uid, token)
end

--获取系统通知
function GetSysNotice(oRole)
	assert(oRole:IsClass(CRole) and oRole.m_Init, "oRole is not validate !")
	local uid, token = oRole.m_uid, oRole.m_token

	return GetAllMail(RoleDef.MailType.SysNotice, uid, token)
end

--获取系统邮件
function GetSysMail(oRole)
	assert(oRole:IsClass(CRole) and oRole.m_Init, "oRole is not validate !")
	local uid, token = oRole.m_uid, oRole.m_token

	return GetAllMail(RoleDef.MailType.SysMail, uid,token)
end

--获取充值邮件
function GetPayMail(oRole)
	assert(oRole:IsClass(CRole) and oRole.m_Init, "oRole is not validate !")
	local uid, token = oRole.m_uid, oRole.m_token

	return GetAllMail(RoleDef.MailType.PayMail, uid, token)
end

-- 查询用户一条邮件信息
function GetOneMail(oRole, guid)
	assert(oRole:IsClass(CRole) and oRole.m_Init, "oRole is not validate !")
	local uid, token = oRole.m_uid, oRole.m_token

    local args = {}
	args.action = "GetOneMail"
	args.uid = uid
	args.token = token
	args.guid= guid
	return ReqEx.ReqDBS(args, nil)
end

-- 增加一条用户读取邮件的记录
function ReadMailTag(oRole, mail_id)
	assert(oRole:IsClass(CRole) and oRole.m_Init, "oRole is not validate !")
	local uid, token = oRole.m_uid, oRole.m_token

    local args = {}
    args.uid=uid
	args.action = "AddMailTag"
	args.read_flag = 1
	args.mail_id= mail_id
	args.token = token
	args.read_time=os.time()
	-- print("S2DBS.fff: ", info)
	local data = ReqEx.ReqDBS(args, nil)
	return data
end

--系统通知
function AddSysNotice(gmName,recv_uid,title,summary,content,attachment,expire_time)
	return AddMail(RoleDef.MailType.SysNotice,gmName, RoleDef.SystemUid,recv_uid,title,summary,content,attachment,expire_time)
end

--系统邮件
function AddSysMail(gmName,recv_uid,title,summary,content,attachment,expire_time)
	return AddMail(RoleDef.MailType.SysMail,gmName, RoleDef.SystemUid,recv_uid,title,summary,content,attachment,expire_time)
end

--用户充值邮件
function AddPayMail(gmName,recv_uid,title,summary,content,attachment,expire_time)
	return AddMail(RoleDef.MailType.PayMail,gmName,RoleDef.SystemUid,recv_uid,title,summary,content,attachment,expire_time)
end

--用户反馈邮件
function AddUserFeedBack(oRole,title,summary,content,attachment)
	assert(oRole:IsClass(CRole) and oRole.m_Init, "oRole is not validate !")
	local uid, token = oRole.m_uid, oRole.m_token

	local args = {}
	args.action = "AddUserFeedBack"
	args.uid= uid
	args.token= token
	args.type=RoleDef.MailType.UserFeedBack
	args.recv_uid = RoleDef.SystemUid
	args.title=title
	args.summary=summary
	args.content=content
	args.attachment=attachment
	args.send_time=os.time()
	--print("dddddddddddd:",args)
	local data = ReqEx.ReqDBS(args, nil)
	return data
end
