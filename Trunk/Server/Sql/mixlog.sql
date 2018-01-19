################################################################
# 
# 	用户数据
# 
################################################################

drop database if exists mixlog;
create database mixlog;
use	mixlog;


# Log 事件记录，普通log记录。
create table tbl_log_normal
(
    guid 					bigint unsigned 	not null auto_increment, 	# 唯一ID，long long
    nowTime 			datetime 					not null, 								# 数据库时间 now()
    uid 					int unsigned 			not null, 								# 账户唯一ID
    eventType 		int unsigned 			not null, 								# 事件类型
    eventReason 	varchar(32) 			not null, 								# 事件原因，包括用户操作、GM操作。
    eventTime 		int unsigned 			not null, 								# 事件时间
    platID 				int unsigned 			not null default 0, 			# 平台ID。0：没有平台，1：安卓，2：IOS，3：windows
    operator 			varchar(32) 			not null default "", 			# 操作人员，有可能是用户、GM_XXX)
    ipAddr 				varchar(32) 			not null default "", 			# ip地址
    sVersion 			varchar(16) 			not null default "", 			# 服务端版本号
    cVersion 			varchar(16) 			not null default "", 			# 客户端版本号
    # 下面为相关详细内容
    extra 				varbinary(1024) 	not null default '', 			# 额外数据。数据过大时，可加入补充表。
    primary key(guid)
)engine=innodb DEFAULT CHARSET=utf8;


# Log 事件记录，账号相关：注册、登录。
# 注册 log 不可删除。登录 log 可以定期处理，只保存当天最后一次登录log。
create table tbl_log_account
(
    guid 					bigint unsigned 	not null auto_increment, 	# 唯一ID，long long
    nowTime 			datetime 					not null, 								# 数据库时间 now()
    uid 					int unsigned 			not null, 								# 账户唯一ID
    eventType 		int unsigned 			not null, 								# 事件类型
    eventReason 	varchar(32) 			not null, 								# 事件原因，包括用户操作、GM操作。
    eventTime 		int unsigned 			not null, 								# 事件时间
    platID 				int unsigned 			not null default 0, 			# 平台ID。0：没有平台，1：安卓，2：IOS，3：windows
    operator 			varchar(32) 			not null default "", 			# 操作人员，有可能是用户、GM_XXX)
    ipAddr 				varchar(32) 			not null default "", 			# ip地址
    sVersion 			varchar(16) 			not null default "", 			# 服务端版本号
    cVersion 			varchar(16) 			not null default "", 			# 客户端版本号
    # 下面为相关详细内容
    location 			varchar(64) 			not null default "", 			# 地理位置。
    primary key(guid)
)engine=innodb DEFAULT CHARSET=utf8;


# Log 事件记录，充值相关：充值、退款。
# 充值、退款 log 不可删除。
create table tbl_log_charge
(
    guid 					bigint unsigned 	not null auto_increment, 	# 唯一ID
    nowTime 			datetime 					not null, 								# 数据库时间 now()
    uid 					int unsigned 			not null, 								# 账户唯一ID
    eventType 		int unsigned 			not null, 								# 事件类型
    eventReason 	varchar(32) 			not null, 								# 事件原因，包括用户操作、GM操作、或者第三方(alipay、wxpay)
    eventTime 		int unsigned 			not null, 								# 事件时间
    platID 				int unsigned 			not null default 0, 			# 平台ID。0：没有平台，1：安卓，2：IOS，3：windows
    operator 			varchar(32) 			not null default "", 			# 操作人员，有可能是用户、GM_XXX)
    ipAddr 				varchar(32) 			not null default "", 			# ip地址
    sVersion 			varchar(16) 			not null default "", 			# 服务端版本号
    cVersion 			varchar(16) 			not null default "", 			# 客户端版本号
    # 下面为相关详细内容
    tradeno 			varchar(32) 			not null, 			# 订单号
    createTime 		int unsigned 			not null, 			# 订单创建时间
    pid 					varchar(32) 			not null, 			# 产品ID，档位
    amount 				double 						not null, 			# 实际支付金额
    payway 				tinyint 					not null, 			# 支付方式。支付宝(AliPay)：1。微信(WeiXin)：2。
    paymod 				tinyint 					not null, 			# 支付模式。二维码(QR)：1。SDK：2。
    primary key(guid)
)engine=innodb DEFAULT CHARSET=utf8;

# 分析log得到留存相关数据
create table tbl_retain_log
(
    guid 					bigint unsigned 	not null auto_increment, 	# 唯一ID
    record_time 	int unsigned 			not null, 								# 本条记录的最后一次更新的日期
    uid 					int unsigned 			not null, 								# 账户唯一ID
    reg_time 			int unsigned 			not null, 								# 注册时间
    ret2 					tinyint(1) 				not null default 0, 			# 次留，第2天是否有登录。0：否，1：是
    ret3 					tinyint(1) 				not null default 0, 			# 三留，第3天是否有登录。0：否，1：是
    ret7 					tinyint(1) 				not null default 0, 			# 周留，第7天是否有登录。0：否，1：是
    ret30 				tinyint(1) 				not null default 0, 			# 月留，第30天是否有登录。0：否，1：是
    count7 				int unsigned 			not null default 1, 			# 注册后，7天内，登录的总天数
    count30 			int unsigned 			not null default 1, 			# 注册后，30天内，登录的总天数
    count_total 	int unsigned 			not null default 1, 			# 注册后，登录的总天数
    primary key(guid)
)engine=innodb DEFAULT CHARSET=utf8;

# 分析log得到付费相关数据
create table tbl_pay_log
(
    guid 					bigint unsigned 	not null auto_increment, 	# 唯一ID
    record_time 	int unsigned 			not null, 								# 本条记录的日期
    platID 				int unsigned 			not null, 								# 平台ID。0：没有平台，1：安卓，2：IOS，3：windows
    payway 				tinyint 					not null, 								# 支付方式。支付宝(AliPay)：1。微信(WeiXin)：2。
    pid 					varchar(32) 			not null, 								# 产品ID，档位
    pay_count 		int unsigned 			not null, 								# 充值次数
    user_count 		int unsigned 			not null, 								# 充值人数
    total_amount 	int unsigned 			not null, 								# 充值总金额
    primary key(guid)
)engine=innodb DEFAULT CHARSET=utf8;
