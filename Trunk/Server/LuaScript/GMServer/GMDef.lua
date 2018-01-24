-- GM Define
module("GMDef", package.seeall)

-- 超级管理员账号。
SuperGM = 
{
	name = "18782200189",
	pass = "306adcb4975c5aec58ffa438b3869d99",
	power = 0, -- 权限，0最高，大于等于此数值的GM命令都可以执行。
	token = '123456',  -- 令牌
	date = '未知',
}
-- 权限范围 1 - 10000 。
GMPowerRange = {1, 10000}
-- 普通GM账号权限
GMNormalPower = 200

-- 模块定义
local DefMType = 
{
	["GMAccout"] = {1, "GM账号系统"}, 
	["ServerCfg"] = {10, "服务器配置"}, 
	["MailSystem"] = {11, "邮件系统"}, 
	["UserAccount"] = {20, "用户账号系统"},

	["UnKnown"] = {100, "未知系统"},
}
-- 参数类型定义
local DefAType = 
{
	["text"] = "text", 
	["password"] = "password", 
	["richtext"] = "richtext", 
	["textarea"] = "textarea", 
	["number"] = "number",
	["tel"] = "tel",
	["file"] = "file", 
	["image"] ="image", 
	["select"] = "select", 
	["hidden"] = "hidden", 
	["checkbox"] = "checkbox", 
	["radio"] = "radio", 
	["submit"] = "submit", 
	["button"] = "button",
}


-- GM 命令列表
GMList = 
{
	-- 指令需要的基本参数有：(action, gmName, gmToken, gmPass)。gmToken, gmPass只填其一，登录指令用gmPass，其他指令用gmToken。
	-- 指令需要的业务参数有：(user、uid、...)。user和uid可以只填其一，若填了user，就以user为准。
	-- key值 ：等价于基本参数action。调用 _G["C2GMS"][key值] 函数执行GM操作。
	-- hide  ：是否在GMTool客户端不展示该指令。默认为 false。
	-- power ：权限数值，数值越小，权限越高。GM人员不能执行权限数值小于自己的GM指令。GM人员不能修改权限数值小于等于自己的GM账号。
	-- mtype ： 类型，不同模块的标志
	-- desc  ： GM指令的描述
	-- args  ： 指令需要的业务参数（除却基本参数外的所有参数）。{name="xxx", atype=n, desc="XXX", default=xx, flag=x}


	-------------------------------- GM 管理员相关指令，权限 1 - 9。 --------------------------------
	-- GM账号不可通过注册创建，可以由其他高级GM账号创建。
	-- GM 登录成功后，会生成一个新的口令 gmToken ，以及下发所有可用的GM指令。
	GMLogin = 
	{
		hide = true, 
		power = 10000, mtype = DefMType.GMAccout, desc = "GM登录", 
		args = {}
	},
	GMModPwd = 
	{
		hide = true, 
		power = 10000, mtype = DefMType.GMAccout, desc = "GM改密", 
		args = 
		{
			{name = "pass", desc = "新密码", atype = DefAType.password}
		}
	},
	GMGetData = 
	{
		hide = true, 
		power = 10000, mtype = DefMType.GMAccout, desc = "GM账号信息", 
		args = {}
	},
	GMGetCmdInfo = 
	{
		hide = true, 
		power = 10000, mtype = DefMType.GMAccout, desc = "GM指令详情", 
		args = 
		{
			{name = "cmd", desc = "GM指令名称", atype = DefAType.text}
		}
	},

	-- GM超级管理员，可以创建、修改、删除其他GM账号。
	AllGM = 
	{
		power = 1, mtype = DefMType.GMAccout, desc = "获取所有GM账号", 
		args = {}
	},
	AddGM = 
	{
		power = 1, mtype = DefMType.GMAccout, desc = "增加其他GM账号", 
		args = 
		{
			{name = "name", desc = "用户名", atype = DefAType.text}, 
			{name = "pass", desc = "密码", atype = DefAType.password}, 
			{name = "power", desc = "权限", atype = DefAType.text, default = GMDef.GMNormalPower}
		}
	},
	DelGM = 
	{
		power = 1, mtype = DefMType.GMAccout, desc = "删除其他GM账号", 
		args = 
		{
			{name = "name", desc = "用户名", atype = DefAType.text}
		}
	},
	ModGM = 
	{
		power = 1, mtype = DefMType.GMAccout, desc = "修改其他GM账号", 
		args = 
		{
			{name = "name", desc = "用户名", atype = DefAType.text}, 
			{name = "pass", desc = "新密码", atype = DefAType.password}, 
			{name = "power", desc = "新权限", atype = DefAType.text}
		}
	},


	-------------------------------- 操作系统数据的 GM 相关指令，权限范围 10 - 99。 --------------------------------
	SetVipLimit = 
	{
		power = 10, mtype = DefMType.ServerCfg, desc = "开(1)/关(0)会员限制功能", 
		args = 
		{
			{name = "on", desc = "开关", atype = DefAType.text}
		}
	},
	SetOpenPay = 
	{
		power = 10, mtype = DefMType.ServerCfg, desc = "开(1)/关(0)充值功能", 
		args = 
		{
			{name = "on", desc = "开关", atype = DefAType.text}
		}
	},
	-- 系统通知、系统邮件之类的
	AddSysNotice = 
	{
		power = 10, mtype = DefMType.MailSystem, desc = "发送系统通知", 
		args = 
		{
			{name = "recv_uid", desc = "收件人", atype = DefAType.text},
			{name = "title", desc = "标题", atype = DefAType.text},
			{name = "summary", desc = "概要", atype = DefAType.text},
			{name = "content", desc = "详情", atype = DefAType.richtext},
			{name = "attachment", desc = "附件", atype = DefAType.text},
			{name = "expire_time", desc = "过期时间", atype = DefAType.text},
		}
	},


	-------------------------------- 操作用户数据的 GM 相关指令，权限范围 100 - 999。 --------------------------------
	-- 查询用户信息的GM命令权限范围 200 - 299
	QueryAllUser = 
	{
		power = 200, mtype = DefMType.UserAccount, desc = "查询用户信息", 
		args = 
		{
			{name = "user", desc = "用户名", atype = DefAType.text},
			{name = "nick", desc = "昵称/企业名", atype = DefAType.text},
			{name = "uid", desc = "用户ID", atype = DefAType.text},
			{name = "status", desc = "账户状态", atype = DefAType.text},
			{name = "type", desc = "账户类型", atype = DefAType.text},
			{name = "owner_uid", desc = "企业主ID", atype = DefAType.text},
		}
	},
	-- 查询授权
	QueryAccountAuth = 
	{
		power = 200, mtype = DefMType.UserAccount, desc = "查询授权", 
		args = 
		{
			{name = "auth_code", desc = "授权码", atype = DefAType.text},
			{name = "auth_type", desc = "授权类型", atype = DefAType.text},
			{name = "auth_status", desc = "授权状态", atype = DefAType.text},
			{name = "sub_uid", desc = "企业子账户ID", atype = DefAType.text},
			{name = "com_uid", desc = "企业账户ID", atype = DefAType.text},
			{name = "auth_uid", desc = "被授权个人账户ID", atype = DefAType.text},
		}
	},
	-- 修改用户信息的GM命令权限范围 100 - 199
	ModifyPass = 
	{
		power = 100, mtype = DefMType.UserAccount, desc = "修改用户密码", 
		args = 
		{
			{name = "user", desc = "用户名(手机号)", atype = DefAType.text}, 
			{name = "uid", desc = "用户ID", atype = DefAType.text},
			{name = "pass", desc = "新密码", atype = DefAType.password}, 
		}
	},
	-- 个人账户（企业主）将自己的面料、沙发数据转移到企业账户中。
	UserDataToComData = 
	{
		power = 100, mtype = DefMType.UserAccount, desc = "企业主-个人数据转企业", 
		args = 
		{
			{name = "user", desc = "用户名(手机号)", atype = DefAType.text}, 
			{name = "uid", desc = "用户ID", atype = DefAType.text}
		}
	},
	-- 企业账户将自己的面料、沙发数据转移到企业主（个人账户）中。
	ComDataToUserData = 
	{
		power = 100, mtype = DefMType.UserAccount, desc = "企业主-企业数据转个人",
		args = 
		{
			{name = "user", desc = "用户名(手机号)", atype = DefAType.text}, 
			{name = "uid", desc = "用户ID", atype = DefAType.text}
		}
	},


	-------------------------------- LogTool 相关指令操作，权限范围 1000 - 9999。 --------------------------------
	--LTStart = {power = 1000, args = {}, desc = "LogTool开始"},
	--LTEnd 	= {power = 9999, args = {}, desc = "LogTool结束"},
	-- 企业账户将自己的面料、沙发数据转移到企业主（个人账户）中。
	Test = 
	{
		power = 10000, mtype = DefMType.UnKnown, desc = "测试所有参数类型",
		args = 
		{
			{name = "text", desc = "text", atype = DefAType.text},
			{name = "password", desc = "password", atype = DefAType.password},
			{name = "richtext", desc = "richtext", atype = DefAType.richtext},
			{name = "textarea", desc = "textarea", atype = DefAType.textarea},
			{name = "number", desc = "number", atype = DefAType.number},
			{name = "tel", desc = "tel", atype = DefAType.tel},
			{name = "file", desc = "file", atype = DefAType.file},
			{name = "image", desc = "image", atype = DefAType.image},
			{name = "select", desc = "select", atype = DefAType.select, value = {1,2,3,4,5}},
			{name = "hidden", desc = "hidden", atype = DefAType.hidden},
			{name = "checkbox", desc = "checkbox", atype = DefAType.checkbox, value = {1,2,3,4,5}},
			{name = "radio", desc = "radio", atype = DefAType.radio,value = {1,2,3,4,5}},
		}
	},
}

-- 获取某个权限能够执行的 GM指令列表
function GetGMList(power)
	if power < 0 or power > 10000 then
		return {}
	end

    local mList = {}
    -- 先处理大的模块
    for i, v in pairs(DefMType) do
    	mList[ v[1] ] = {index = v[1], desc = v[2], list = {}}
    end
    -- 再处理GM指令
    local allGmList = TextCode.JsonDecode(TextCode.JsonEncode(GMList))
    for i, v in pairs(allGmList) do
    	if v.power >= power and not v.hide then
	    	local idx = DefMType["UnKnown"][1]
	    	if v.mtype and mList[ v.mtype[1] ] then
	    		idx = v.mtype[1]
	    	end
	    	v.mtype = nil
	    	v.action = i
	    	table.insert(mList[idx].list, v)
    	end
    end

    -- 重新组成数组
    local gmList = {}
    for i, v in pairs(mList) do
    	if next(v.list) then
	    	table.sort(v.list, function(first, second)
	    		if first.power < second.power then
	    			return true
	    		else
	    			return false 
	    		end
	    	end)
	    	table.insert(gmList, v)
	    end
    end
    table.sort(gmList, function(first, second)
    	if first.index < second.index then
    		return true
    	else
    		return false
    	end
    end)

    return gmList
end
