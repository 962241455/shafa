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

-- GM 命令列表
GMList = 
{
	-- 指令需要的基本参数有：(action, gmName, gmToken, gmPass)。gmToken, gmPass只填其一，登录指令用gmPass，其他指令用gmToken。
	-- 指令需要的业务参数有：(user、uid、...)。user和uid可以只填其一，若填了user，就以user为准。
	-- key值：等价于基本参数action。调用 _G["C2GMS"][key值] 函数执行GM操作。
	-- power：权限数值，数值越小，权限越高。GM人员不能执行权限数值小于自己的GM指令。GM人员不能修改权限数值小于等于自己的GM账号。
	-- args： 指令需要的业务参数（除却基本参数外的所有参数）。
	-- desc： GM指令描述
	-- subAct：子命令。key值对应的GM指令执行后会产生一个结果，对这个结果可以继续使用子命令做进一步的处理。
	-- notShow：是否在GMTool客户端不展示该指令。默认为 false。
	-- 尽量保证GM指令参数名与数据库中的字段名一致，否则无法使用子命令。
	-------------------------------- GM 管理员相关指令，权限 1 - 9。 --------------------------------
	-- GM账号不可通过注册创建，可以由其他高级GM账号创建。
	-- GM 登录成功后，会生成一个新的口令 gmToken ，以及下发所有可用的GM指令。
	GMLogin 	= {notShow = true, power = 10000, args = {}, desc = "GM登录"},
	GMModPwd 	= {notShow = true, power = 10000, args = {"pass"}, desc = "GM改密"},
	GMGetData 	= {notShow = true, power = 10000, args = {}, desc = "获取GM 账号信息、GMList"},
	GMGetCmdInfo = {notShow = true, power = 10000, args = {"cmd"}, desc = "获取某条GM指令的详细信息"},
	-- GM超级管理员，可以创建、修改、删除其他GM账号。
	AllGM 	= {power = 1, args = {}, desc = "获取所有GM账号", subAct = {"AddGM", "DelGM", "ModGM"}},
	AddGM 	= {power = 1, args = {"name", "pass", "power"}, desc = "增加其他GM账号"},
	DelGM 	= {power = 1, args = {"name"}, desc = "删除其他GM账号"},
	ModGM 	= {power = 1, args = {"name", "pass", "power"}, desc = "修改其他GM账号"},


	-------------------------------- 操作系统数据的 GM 相关指令，权限范围 10 - 99。 --------------------------------
	SetVipLimit 	= {power = 10, args = {"on"}, desc = "开启(1)或者关闭(0)会员限制功能"},
	SetOpenPay 	= {power = 10, args = {"on"}, desc = "开启(1)或者关闭(0)充值功能"},
	-- 系统通知、系统邮件之类的
	AddSysNotice = {power = 10, args = {"recv_uid", "title", "summary", "content", "attachment", "expire_time"}, desc = "增加一条系统通知"},


	-------------------------------- 操作用户数据的 GM 相关指令，权限范围 100 - 999。 --------------------------------
	-- 查询用户信息的GM命令权限范围 200 - 299
	QueryAllUser = {power = 200, args = {"user", "nick", "uid", "status", "type", "owner_uid"}, desc = "查询用户信息", subAct = {"ModifyPass"}},
	-- 查询授权
	QueryAccountAuth = {power = 200, args = {"auth_code", "auth_type", "auth_status", "sub_uid", "com_uid", "auth_uid"}, desc = "查询授权"},
	-- 修改用户信息的GM命令权限范围 100 - 199
	ModifyPass 	= {power = 100, args = {"user", "uid", "pass"}, desc = "修改用户密码"},
	-- 个人账户（企业主）将自己的面料、沙发数据转移到企业账户中。
	UserDataToComData 	= {power = 100, args = {"user", "uid", "com_uid"}, desc = "企业主将个人数据转移到企业账户中"},
	-- 企业账户将自己的面料、沙发数据转移到企业主（个人账户）中。
	ComDataToUserData 	= {power = 100, args = {"user", "uid"}, desc = "企业主将企业数据转移到个人账户中"},


	-------------------------------- LogTool 相关指令操作，权限范围 1000 - 9999。 --------------------------------
	--LTStart = {power = 1000, args = {}, desc = "LogTool开始"},
	--LTEnd 	= {power = 9999, args = {}, desc = "LogTool结束"},
}
