use	mixlog;

########################################################
#                       增加新表                       #
########################################################

# 分析log得到留存相关数据
create table if not exists tbl_retain_log
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
create table if not exists tbl_pay_log
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
