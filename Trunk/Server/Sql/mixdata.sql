################################################################
# 
# 	用户数据
# 
################################################################

drop database if exists mixdata;
create database mixdata;
use	mixdata;

# 创建一个空表，insert into ... select ... 常数的时候需要用到它。 
create table empty
(
    id 				tinyint				not null default 0,
    primary key(id)
)engine=innodb DEFAULT CHARSET=utf8;
insert into empty(id) values(0);
# insert into tbl_test1(guid, name) select '1', '1' from empty where not exists(select * from tbl_test1 where guid = '1');

#短信验证码
create table tbl_idtc
(
    phno 				varchar(32) 				not null, 								# 电话号码
    idtc 				varchar(16) 				not null default '', 			# 手机验证码
    idtcTime 		int unsigned 				not null default 0, 			# 手机验证码生成时间
    flag 				tinyint 						not null default 0, 			# 是否使用的标志。0：表示未被使用，1：表示已经被使用。
    extra				varchar(256) 				not null default '', 			# 短信平台返回的额外数据
    primary key(phno)
)engine=innodb DEFAULT CHARSET=utf8;

#账户信息
create table tbl_account
(
    uid 					int unsigned				not null auto_increment, 	# 账户唯一ID
    user 					varchar(32) 				not null, 								# 账号，电话号码
    pass 					varchar(32) 				not null, 								# 密码
    type 					tinyint 						not null, 								# 账号类型。0：个人账户。1：企业账户。2：企业子账户(虚拟账户)。10：游客账户。
    status 				tinyint 						not null default 0,				# 账号状态。0：正常状态。1：删除状态。
    owner_uid 		int unsigned				not null default 0,				# 企业账户和企业子账户 的拥有者的uid。
    com_cnt 			int unsigned				not null default 0,				# 创建企业账户的次数。
    date 					datetime            not null, 								# 注册日期
    userip 				varchar(64) 				not null default '', 			# 注册时 IP
    location 			varchar(64) 				not null default '', 			# 注册时 地理位置
    nick 					varchar(64) 				not null default '', 			# 昵称
    head 					varchar(64) 				not null default '',			# 头像，图片文件路径。
    token 				varchar(32) 				not null default '', 			# 令牌
    tokenTime 		int unsigned 				not null default 0, 			# 令牌起效时间
    # vip 相关
    total_amount 	double 							not null default 0, 			# 充值总额
    expire_time 	int unsigned 				not null default 0, 			# 会员到期时间
    # 约束
    CONSTRAINT uq_user UNIQUE (user),
    primary key(uid)
)engine=innodb DEFAULT CHARSET=utf8;
alter table tbl_account AUTO_INCREMENT=1000001;

#企业账户授权给子账户
create table tbl_account_auth
(
    auth_code 		varchar(32) 				not null, 								# 唯一ID，授权码。
    auth_type 		tinyint 						not null default 0,				# 授权码类型。0：企业子账号--职员账户。1：企业子账号--老板账户。
    auth_status 	tinyint 						not null default 0,				# 授权码状态。0：授权中，企业账户发出邀请。1：生效状态。2：失效状态。3：申请中，个人账户提出申请。
    sub_uid 			int unsigned, 																# 被授权的账户，企业子账户uid(虚拟账户)。
    com_uid 			int unsigned				not null, 								# 授权主体账户，企业账户uid。
    auth_uid 			int unsigned				not null, 								# 被授权的账户，个人账户uid。
    grant_time 		int unsigned 				not null, 								# 授权(申请或者邀请)开始时间。
    finish_time 	int unsigned 				not null, 								# 授权(申请或者邀请)完成时间。
    # 约束
    CONSTRAINT tbl_account_auth_uq_uid UNIQUE (com_uid, auth_uid),
    CONSTRAINT tbl_account_auth_uq_sub_uid UNIQUE (sub_uid),
    primary key(auth_code)
)engine=innodb DEFAULT CHARSET=utf8;

#支付相关
create table tbl_pay
(
    trade_no 		varchar(32) 				not null, 						# 订单号
    type 				tinyint 						not null, 						# 类型，保留字段。
    uid 				int unsigned				not null, 						# 账户ID
		pid 				varchar(32) 				not null, 						# 产品ID
    statu 			tinyint 						not null default 0, 	# 0：表示等待付款，1：表示已经付款，交易完成，2：已经失效过期。
    amount			double 							not null, 						# 金额
    add_time 		int unsigned				not null, 						# 增加会员时间，单位天
    cre_time 		int unsigned 				not null default 0, 	# 生成时间
    done_time 	int unsigned 				not null default 0, 	# 完成时间
    extra				varchar(256) 				not null default '', 	# 第三方支付返回的额外数据
    CONSTRAINT fk_p_uid foreign key(uid) references tbl_account(uid) on delete cascade on update cascade,
    primary key(trade_no)
)engine=innodb DEFAULT CHARSET=utf8;

#用户面料信息
create table tbl_cloth_info
(
		guid 				varchar(32) 				not null, 						# 面料唯一ID
    uid 				int unsigned				not null, 						# 账户ID
		cid 				varchar(32) 				not null, 						# 客户端面料唯一ID
    name 				varchar(128) 				not null, 						# 面料名字
    tag 				varchar(128) 				not null, 						# 标签名字
    mtime 			int unsigned 				not null default 0, 	# 面料修改时间
    time 				varchar(64) 				not null, 						# 面料图片拍摄时间
    path 				varchar(64) 				not null, 						# 面料图片文件路径(md5-size)
    scaleX 			double 							not null default 1, 	# 面料 X方向 缩放系数
    scaleY 			double 							not null default 1, 	# 面料 Y方向 缩放系数
    extra 			varchar(128) 				not null default '', 	# 客户端上传的额外数据
    foreign key(uid) references tbl_account(uid) on delete cascade on update cascade,
    primary key(guid)
)engine=innodb DEFAULT CHARSET=utf8;

#用户面料标签信息
create table tbl_tag_info
(
    guid 				varchar(32) 				not null, 						# 标签唯一ID
    uid 				int unsigned				not null, 						# 账户ID
		cid 				varchar(32) 				not null, 						# 标签客户端唯一ID
    name 				varchar(128) 				not null, 						# 标签名字
    time 				varchar(64) 				not null, 						# 标签创建时间
    mtime 			int unsigned 				not null default 0, 	# 标签修改时间
    foreign key(uid) references tbl_account(uid) on delete cascade on update cascade,
    primary key(guid)
)engine=innodb DEFAULT CHARSET=utf8;

#用户沙发模型信息
create table tbl_sofa_info
(
		guid 				varchar(32) 				not null, 						# 唯一ID
    uid 				int unsigned				not null, 						# 账户ID
		cid 				varchar(32) 				not null, 						# 客户端唯一ID
    type 				tinyint 						not null default 0, 	# 类型。0：沙发造型。1：沙发配色方案。
    mtime 			int unsigned 				not null default 0, 	# 修改时间
    time 				varchar(64) 				not null, 						# 沙发模型的时间
    name 				varchar(128) 				not null, 						# 名字
    data 				varbinary(8096) 		not null, 						# 数据，不能超过8K。
    icon 				varbinary(51200) 		not null, 						# icon数据，不能超过50K。
    foreign key(uid) references tbl_account(uid) on delete cascade on update cascade,
    primary key(guid)
)engine=innodb DEFAULT CHARSET=utf8;

# 邮件系统
create table tbl_mail
(
    guid 					bigint unsigned 	not null auto_increment, 	# 唯一ID
    type 					tinyint 					not null default 0, 			# 类型。系统通知：0，系统邮件：1，充值记录：2。
    nowTime 			datetime 					not null, 								# 数据库时间 now()
    gmName 				varchar(32) 			not null default '', 			# 如果是GM发送的邮件，需要填此项 gmName。
    send_uid 			int unsigned 			not null, 								# 发送者 uid。
    recv_uid 			int unsigned 			not null, 								# 接收者 uid。
    title 				varchar(64) 			not null, 								# 标题
    summary 			varchar(255) 			not null, 								# 摘要
    content 			text 							not null, 								# 内容
    attachment 		text 							not null, 								# 附件
    send_time 		int unsigned 			not null, 								# 邮件发送时间
    expire_time 	int unsigned 			not null default 0, 			# 邮件过期时间。0：永不过期。
    primary key(guid)
)engine=innodb AUTO_INCREMENT=10000 DEFAULT CHARSET=utf8;

# 邮件 状态
create table tbl_mail_status
(
    guid 					bigint unsigned 	not null auto_increment, 	# 唯一ID
    uid 					int unsigned 			not null, 								# 接收者 uid。
    mail_id 			bigint unsigned 	not null, 								# 邮件唯一ID
    read_flag 		tinyint 					not null default 0, 			# 邮件读取标志。未读取：0，已读取：1。
    read_time 		int unsigned 			not null default 0, 			# 邮件读取时间
    recv_flag 		tinyint 					not null default 0, 			# 附件领取标志。未领取：0，已领取：1。
    recv_time 		int unsigned 			not null default 0, 			# 附件领取时间
    foreign key(mail_id) references tbl_mail(guid) on delete cascade on update cascade,
    primary key(guid)
)engine=innodb AUTO_INCREMENT=10000 DEFAULT CHARSET=utf8;
