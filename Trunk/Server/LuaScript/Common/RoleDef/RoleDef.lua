-- RoleDef
module("RoleDef", package.seeall)

-- 平台定义。0：没有平台，1：安卓，2：IOS，3：windows
Platform = {}
Platform.None = 0
Platform.Android = 1
Platform.IOS = 2
Platform.Windows = 3
Platform.WebBrowser = 10 	-- 网页浏览器
Platform.Editor = 100 	-- unity3d 编辑器

-- 支付方式定义
PayWay = {}
PayWay["None"] = 0
PayWay["AliPay"] = 1
PayWay["WeiXin"] = 2

-- 支付模式定义
PayMod = {}
PayMod["None"] = 0
PayMod["QR"] = 1
PayMod["SDK"] = 2

-- 充值产品的类别
PayGroup = {
	Person = 0, 	-- 个人充值产品
	Company = 1, 	-- 企业充值产品
}

-- GM 相关action 定义
GMAction = "GM"

-- 系统角色id
SystemUid = 10000
-- 所有用户
AllUid = 0


-- 账号类型。0：个人账户。1：企业账户。2：企业子账户(虚拟账户)。10：游客账户。
UserType = {
	User = 0,
	Com = 1,
	Sub = 2,
	Guest = 10,
}

-- 账号状态。0：正常状态。1：删除状态。2：创建中。
UserStatus = {
	Normal = 0,
	Delete = 1,
	--Creating = 2,
}

-- 授权码类型。0：企业子账号--职员账户。1：企业子账号--老板账户。2：企业子账户--管理员。
AuthType = {
	Member = 0,
	Owner = 1,
	--Master = 2,
}

-- 授权码状态。0：授权中，企业账户发出邀请。1：生效状态。2：失效状态。3：申请中，个人账户提出申请。
AuthStatus = {
	Authing = 0,
	Normal = 1,
	Delete = 2,
	Apply = 3,
}

-- 沙发造型类型
SofaType = {
	SofaModel = 0, 	-- 沙发造型
	SofaColor = 1, 	-- 沙发配色
}

-- 邮件类型枚举
MailType = {
	SysNotice = 1, 	-- 系统通知
	SysMail = 2, 	-- 系统邮件
	PayMail = 3, 	-- 充值邮件
	UserMail = 4, 	-- 用户邮件
	UserFeedBack = 5, -- 用户反馈
}
