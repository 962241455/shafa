-- 服务器配置，包括 nginx.conf 中的配置
_G["ServCfg"] = {}

-- 邮件默认过期时间，30天。
_G["ServCfg"]["mail_expire_time"] = 30 * 86400
-- 注册个人账户，赠送vip时间 30天。
_G["ServCfg"]["register_vip_gift"] = 30 * 86400
-- 首次创建企业账户，赠送企业vip时间 30天。
_G["ServCfg"]["createcom_vip_gift"] = 30 * 86400

-- 数据同步的限制。
_G["ServCfg"]["SyncLimit"] = 
{
	-- -1：无限制。0：完全限制(vip限制，非会员无法操作)。n：限制的条数，正整数。
	-- 先判断是否能够同步，再判断云端存储数量上限。
	-- Sync ：能否同步到服务端并且云端存储，包括新增、删除、修改、获取。配置只能是-1或0。
	-- AddCloth ：服务端存储面料上限n。 AddModel ：服务端存储沙发造型上限n。 AddColor ：服务端存储沙发配色上限n。
	-- NewCloth ：客户端新建面料上限n。 NewModel ：客户端新建沙发造型上限n。 NewColor ：客户端新建沙发配色上限n。
	-- AR：客户端AR的限制。配置只能是-1或0。
	-- Share：客户端分享的限制。配置只能是-1或0。

	-- 完全限制，非法账户、特殊类型账户是不准同步的。
	AllLimit  = {Sync =  0, AddCloth =  0, AddModel =  0, AddColor =  0, NewCloth =  0, NewModel =  0, NewColor =  0, AR =  0, Share =  0},
	-- 游客 相关限制 的上限
	Guest     = {Sync = -1, AddCloth = 100, AddModel =  10, AddColor =  30, NewCloth = 100, NewModel =  10, NewColor =  30, AR = -1, Share = -1},
	-- 个人账户 相关限制 的上限
	UserNoVip = {Sync =  0, AddCloth =  0, AddModel =  0, AddColor =  0, NewCloth =  0, NewModel =  0, NewColor =  0, AR = -1, Share = -1},
	UserVip   = {Sync = -1, AddCloth = 100, AddModel =  10, AddColor =  30, NewCloth = 100, NewModel =  10, NewColor =  30, AR = -1, Share = -1},
	-- 企业账户 相关限制 的上限
	ComNoVip  = {Sync =  0, AddCloth =  0, AddModel =  0, AddColor =  0, NewCloth = -1, NewModel = -1, NewColor = -1, AR = -1, Share = -1},
	ComVip    = {Sync = -1, AddCloth = -1, AddModel = -1, AddColor = -1, NewCloth = -1, NewModel = -1, NewColor = -1, AR = -1, Share = -1},
}



local mtTbl = {}
function mtTbl.__index( tbl, key )
	local xValue = rawget(tbl, key)
	if not xValue then
		if type(ServerCfg["get_" .. key]) == 'function' then
			xValue = ServerCfg["get_" .. key]()
		else
			xValue = ngx.var[key]
		end
        --rawset( tbl, key, xValue )
	end
	return xValue
end
setmetatable(_G["ServCfg"], mtTbl)



-- ServerCfg/ServCfg 服务器配置，包括 nginx.conf 中的配置变量
module("ServerCfg", package.seeall)

-- 否是本地发起的请求。可以针对文件服务器(FLServer)做优化。
function get_islocal()
	local ck = tonumber(ngx.var.islocal) or 0
	--print("get_islocal: " ..  ck)
	return (ck == 1)
end

-- 获取客户端IP。
function get_client_addr()
	--print("get_client_addr: " ..  ngx.var.remote_addr)
	return ngx.var.remote_addr
end

-- 是否需要检查协议签名。1：是；0：否。默认 1
function get_check_sign()
	local ck = tonumber(ngx.var.check_sign) or 1
	--print("get_check_sign: " ..  ck)
	return ck
end

-- 是否需要检查短信验证码。1：是；0：否。默认 1
function get_check_idtc()
	local ck = tonumber(ngx.var.check_idtc) or 1
	--print("get_check_idtc: " ..  ck)
	return ck
end

-- 是否开放充值功能。1：是；0：否。默认 1
function get_open_pay()
	local ck = tonumber(ngx.var.open_pay) or 1
	--print("get_open_pay: " ..  ck)
	return ck
end

-- 是否有会员功能限制(只有会员才能使用某些功能)。1：是；0：否。默认 1
function get_vip_limit()
	local ck = tonumber(ngx.var.vip_limit) or 1
	--print("get_vip_limit: " ..  ck)
	return ck
end

-- 支付宝回调地址
function get_alipay_notify_url()
	--print("get_alipay_notify_url: " ..  ngx.var.alipay_notify_url)
	return ngx.var.alipay_notify_url
end

-- 微信支付回调地址
function get_wxpay_notify_url()
	--print("get_wxpay_notify_url: " ..  ngx.var.wxpay_notify_url)
	return ngx.var.wxpay_notify_url
end

-- DBServer url地址
function get_dbs_url()
	--print("get_dbs_url: " ..  ngx.var.dbs_url)
	return ngx.var.dbs_url
end

-- FLServer url地址
function get_fls_url()
	--print("get_fls_url: " ..  ngx.var.fls_url)
	return ngx.var.fls_url
end

-- LogServer url地址
function get_logs_url()
	--print("get_logs_url: " ..  ngx.var.logs_url)
	return ngx.var.logs_url
end

-- 获取 Version 相关配置
function get_Version()
	local cfg = {}
	cfg.MaxVersion = ngx.var.MaxVersion
	cfg.MinVersion = ngx.var.MinVersion
	cfg.AppDownUrl = {}
	cfg.AppDownUrl.Android = ngx.var.AndroidDownUrl
	cfg.AppDownUrl.IOS = ngx.var.IOSDownUrl
	cfg.AppDownUrl.Win = ngx.var.WinDownUrl
	--print("get_Version: ", cfg)
	return cfg
end

-- 获取 DBServer mysql 相关配置
function get_DBSMysqlCfg()
	local cfg = {}
	cfg.db_host = ngx.var.db_host
	cfg.db_port = ngx.var.db_port
	cfg.db_user = ngx.var.db_user
	cfg.db_pwd = ngx.var.db_pwd
	cfg.db_db = ngx.var.db_db
	cfg.db_keepTime = ngx.var.db_keepTime
	cfg.db_ConnNum = ngx.var.db_ConnNum
	--print("get_DBSMysqlCfg: ", cfg)
	return cfg
end

-- 获取 LogServer mysql 相关配置
function get_LogMysqlCfg()
	local cfg = {}
	cfg.log_host = ngx.var.log_host
	cfg.log_port = ngx.var.log_port
	cfg.log_user = ngx.var.log_user
	cfg.log_pwd = ngx.var.log_pwd
	cfg.log_db = ngx.var.log_db
	cfg.log_keepTime = ngx.var.log_keepTime
	cfg.log_ConnNum = ngx.var.log_ConnNum
	--print("get_LogMysqlCfg: ", cfg)
	return cfg
end

-- 获取 GMServer mysql 相关配置
function get_GMSMysqlCfg()
	local cfg = {}
	cfg.gms_host = ngx.var.gms_host
	cfg.gms_port = ngx.var.gms_port
	cfg.gms_user = ngx.var.gms_user
	cfg.gms_pwd = ngx.var.gms_pwd
	cfg.gms_db = ngx.var.gms_db
	cfg.gms_keepTime = ngx.var.gms_keepTime
	cfg.gms_ConnNum = ngx.var.gms_ConnNum
	--print("get_GMSMysqlCfg: ", cfg)
	return cfg
end
