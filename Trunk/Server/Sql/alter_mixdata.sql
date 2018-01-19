use	mixdata;

########################################################
#                       增加新表                       #
########################################################

#企业账户授权给子账户
create table if not exists tbl_account_auth
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

#用户面料信息
create table if not exists tbl_cloth_info
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
create table if not exists tbl_tag_info
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
create table if not exists tbl_sofa_info
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
create table if not exists tbl_mail
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
create table if not exists tbl_mail_status
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

########################################################
#                       修改字段                       #
########################################################
drop procedure if exists schema_change;
delimiter ';;';
create procedure schema_change() begin
	# 测试用
	#if not exists (select COLUMN_NAME from information_schema.COLUMNS where TABLE_SCHEMA = "mixdata" and TABLE_NAME = "tbl_idtc" and COLUMN_NAME = "Test") then
	#	alter table tbl_idtc add column Test varchar(255) not null default "" after idtcTime;
	#end if;
	#if exists (select COLUMN_NAME from information_schema.COLUMNS where TABLE_SCHEMA = "mixdata" and TABLE_NAME = "tbl_idtc" and COLUMN_NAME = "Test") then
	#	alter table tbl_idtc alter column Test set default "test";
	#end if;
	#if exists (select COLUMN_NAME from information_schema.COLUMNS where TABLE_SCHEMA = "mixdata" and TABLE_NAME = "tbl_idtc" and COLUMN_NAME = "Test") then
	#	alter table tbl_idtc drop column Test;
	#end if;
	#if not exists (SELECT * FROM information_schema.TABLE_CONSTRAINTS where TABLE_SCHEMA = "mixdata" and TABLE_NAME = "tbl_account" and CONSTRAINT_NAME = "uq_nick") then
	#	alter table tbl_account add UNIQUE uq_nick(nick);
	#end if;
	
	
	# tbl_idtc 短信验证码
	if not exists (select COLUMN_NAME from information_schema.COLUMNS where TABLE_SCHEMA = "mixdata" and TABLE_NAME = "tbl_idtc" and COLUMN_NAME = "flag") then
		alter table tbl_idtc add column flag tinyint not null default 0 after idtcTime;
	end if;
	if not exists (select COLUMN_NAME from information_schema.COLUMNS where TABLE_SCHEMA = "mixdata" and TABLE_NAME = "tbl_idtc" and COLUMN_NAME = "extra") then
		alter table tbl_idtc add column extra varchar(256) not null default '' after flag;
	end if;
	
	# tbl_account 用户表
	if not exists (select COLUMN_NAME from information_schema.COLUMNS where TABLE_SCHEMA = "mixdata" and TABLE_NAME = "tbl_account" and COLUMN_NAME = "userip") then
		alter table tbl_account add column userip varchar(64) not null default '' after date;
	end if;
	if not exists (select COLUMN_NAME from information_schema.COLUMNS where TABLE_SCHEMA = "mixdata" and TABLE_NAME = "tbl_account" and COLUMN_NAME = "total_amount") then
		alter table tbl_account add column total_amount double not null default 0 after tokenTime;
	end if;
	if not exists (select COLUMN_NAME from information_schema.COLUMNS where TABLE_SCHEMA = "mixdata" and TABLE_NAME = "tbl_account" and COLUMN_NAME = "expire_time") then
		alter table tbl_account add column expire_time int unsigned not null default 0 after total_amount;
	end if;
	update tbl_account set nick=user where nick='';
	if not exists (select COLUMN_NAME from information_schema.COLUMNS where TABLE_SCHEMA = "mixdata" and TABLE_NAME = "tbl_account" and COLUMN_NAME = "status") then
		alter table tbl_account add column status tinyint not null default 0 after type;
	end if;
	if not exists (select COLUMN_NAME from information_schema.COLUMNS where TABLE_SCHEMA = "mixdata" and TABLE_NAME = "tbl_account" and COLUMN_NAME = "owner_uid") then
		alter table tbl_account add column owner_uid int unsigned not null default 0 after status;
	end if;
	if not exists (select COLUMN_NAME from information_schema.COLUMNS where TABLE_SCHEMA = "mixdata" and TABLE_NAME = "tbl_account" and COLUMN_NAME = "com_cnt") then
		alter table tbl_account add column com_cnt int unsigned not null default 0 after owner_uid;
	end if;
	if not exists (select COLUMN_NAME from information_schema.COLUMNS where TABLE_SCHEMA = "mixdata" and TABLE_NAME = "tbl_account" and COLUMN_NAME = "head") then
		alter table tbl_account add column head varchar(64) not null default '' after nick;
	end if;
	# 特殊处理
	update tbl_cloth_info set path=concat(concat(uid, '/Cloth/'),path) where path != '' and path not like '%Cloth/%';
	update tbl_account set head=concat(concat(uid, '/HeadImg/'),head) where head != '' and head not like '%HeadImg/%';
	# 去掉 tbl_tag_info 表中 (uid, cid) 的唯一属性。
	if exists (SELECT * FROM information_schema.TABLE_CONSTRAINTS where TABLE_SCHEMA = "mixdata" and TABLE_NAME = "tbl_tag_info" and CONSTRAINT_NAME = "uq_tid") then
		alter table tbl_tag_info drop foreign key tbl_tag_info_ibfk_1;
		alter table tbl_tag_info drop index uq_tid;
		alter table tbl_tag_info add foreign key(uid) references tbl_account(uid) on delete cascade on update cascade;
	end if;
	
	# tbl_sofa_info
	if not exists (select COLUMN_NAME from information_schema.COLUMNS where TABLE_SCHEMA = "mixdata" and TABLE_NAME = "tbl_sofa_info" and COLUMN_NAME = "type") then
		alter table tbl_sofa_info add column type tinyint not null default 0 after cid;
	end if;
end;;
delimiter ';';
call schema_change();
drop procedure if exists schema_change;
