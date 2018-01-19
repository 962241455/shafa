use	mixdata;

########################################################
#                       �����±�                       #
########################################################

#��ҵ�˻���Ȩ�����˻�
create table if not exists tbl_account_auth
(
    auth_code 		varchar(32) 				not null, 								# ΨһID����Ȩ�롣
    auth_type 		tinyint 						not null default 0,				# ��Ȩ�����͡�0����ҵ���˺�--ְԱ�˻���1����ҵ���˺�--�ϰ��˻���
    auth_status 	tinyint 						not null default 0,				# ��Ȩ��״̬��0����Ȩ�У���ҵ�˻��������롣1����Ч״̬��2��ʧЧ״̬��3�������У������˻�������롣
    sub_uid 			int unsigned, 																# ����Ȩ���˻�����ҵ���˻�uid(�����˻�)��
    com_uid 			int unsigned				not null, 								# ��Ȩ�����˻�����ҵ�˻�uid��
    auth_uid 			int unsigned				not null, 								# ����Ȩ���˻��������˻�uid��
    grant_time 		int unsigned 				not null, 								# ��Ȩ(�����������)��ʼʱ�䡣
    finish_time 	int unsigned 				not null, 								# ��Ȩ(�����������)���ʱ�䡣
    # Լ��
    CONSTRAINT tbl_account_auth_uq_uid UNIQUE (com_uid, auth_uid),
    CONSTRAINT tbl_account_auth_uq_sub_uid UNIQUE (sub_uid),
    primary key(auth_code)
)engine=innodb DEFAULT CHARSET=utf8;

#�û�������Ϣ
create table if not exists tbl_cloth_info
(
		guid 				varchar(32) 				not null, 						# ����ΨһID
    uid 				int unsigned				not null, 						# �˻�ID
		cid 				varchar(32) 				not null, 						# �ͻ�������ΨһID
    name 				varchar(128) 				not null, 						# ��������
    tag 				varchar(128) 				not null, 						# ��ǩ����
    mtime 			int unsigned 				not null default 0, 	# �����޸�ʱ��
    time 				varchar(64) 				not null, 						# ����ͼƬ����ʱ��
    path 				varchar(64) 				not null, 						# ����ͼƬ�ļ�·��(md5-size)
    scaleX 			double 							not null default 1, 	# ���� X���� ����ϵ��
    scaleY 			double 							not null default 1, 	# ���� Y���� ����ϵ��
    extra 			varchar(128) 				not null default '', 	# �ͻ����ϴ��Ķ�������
    foreign key(uid) references tbl_account(uid) on delete cascade on update cascade,
    primary key(guid)
)engine=innodb DEFAULT CHARSET=utf8;

#�û����ϱ�ǩ��Ϣ
create table if not exists tbl_tag_info
(
    guid 				varchar(32) 				not null, 						# ��ǩΨһID
    uid 				int unsigned				not null, 						# �˻�ID
		cid 				varchar(32) 				not null, 						# ��ǩ�ͻ���ΨһID
    name 				varchar(128) 				not null, 						# ��ǩ����
    time 				varchar(64) 				not null, 						# ��ǩ����ʱ��
    mtime 			int unsigned 				not null default 0, 	# ��ǩ�޸�ʱ��
    foreign key(uid) references tbl_account(uid) on delete cascade on update cascade,
    primary key(guid)
)engine=innodb DEFAULT CHARSET=utf8;

#�û�ɳ��ģ����Ϣ
create table if not exists tbl_sofa_info
(
		guid 				varchar(32) 				not null, 						# ΨһID
    uid 				int unsigned				not null, 						# �˻�ID
		cid 				varchar(32) 				not null, 						# �ͻ���ΨһID
    type 				tinyint 						not null default 0, 	# ���͡�0��ɳ�����͡�1��ɳ����ɫ������
    mtime 			int unsigned 				not null default 0, 	# �޸�ʱ��
    time 				varchar(64) 				not null, 						# ɳ��ģ�͵�ʱ��
    name 				varchar(128) 				not null, 						# ����
    data 				varbinary(8096) 		not null, 						# ���ݣ����ܳ���8K��
    icon 				varbinary(51200) 		not null, 						# icon���ݣ����ܳ���50K��
    foreign key(uid) references tbl_account(uid) on delete cascade on update cascade,
    primary key(guid)
)engine=innodb DEFAULT CHARSET=utf8;

# �ʼ�ϵͳ
create table if not exists tbl_mail
(
    guid 					bigint unsigned 	not null auto_increment, 	# ΨһID
    type 					tinyint 					not null default 0, 			# ���͡�ϵͳ֪ͨ��0��ϵͳ�ʼ���1����ֵ��¼��2��
    nowTime 			datetime 					not null, 								# ���ݿ�ʱ�� now()
    gmName 				varchar(32) 			not null default '', 			# �����GM���͵��ʼ�����Ҫ����� gmName��
    send_uid 			int unsigned 			not null, 								# ������ uid��
    recv_uid 			int unsigned 			not null, 								# ������ uid��
    title 				varchar(64) 			not null, 								# ����
    summary 			varchar(255) 			not null, 								# ժҪ
    content 			text 							not null, 								# ����
    attachment 		text 							not null, 								# ����
    send_time 		int unsigned 			not null, 								# �ʼ�����ʱ��
    expire_time 	int unsigned 			not null default 0, 			# �ʼ�����ʱ�䡣0���������ڡ�
    primary key(guid)
)engine=innodb AUTO_INCREMENT=10000 DEFAULT CHARSET=utf8;

# �ʼ� ״̬
create table if not exists tbl_mail_status
(
    guid 					bigint unsigned 	not null auto_increment, 	# ΨһID
    uid 					int unsigned 			not null, 								# ������ uid��
    mail_id 			bigint unsigned 	not null, 								# �ʼ�ΨһID
    read_flag 		tinyint 					not null default 0, 			# �ʼ���ȡ��־��δ��ȡ��0���Ѷ�ȡ��1��
    read_time 		int unsigned 			not null default 0, 			# �ʼ���ȡʱ��
    recv_flag 		tinyint 					not null default 0, 			# ������ȡ��־��δ��ȡ��0������ȡ��1��
    recv_time 		int unsigned 			not null default 0, 			# ������ȡʱ��
    foreign key(mail_id) references tbl_mail(guid) on delete cascade on update cascade,
    primary key(guid)
)engine=innodb AUTO_INCREMENT=10000 DEFAULT CHARSET=utf8;

########################################################
#                       �޸��ֶ�                       #
########################################################
drop procedure if exists schema_change;
delimiter ';;';
create procedure schema_change() begin
	# ������
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
	
	
	# tbl_idtc ������֤��
	if not exists (select COLUMN_NAME from information_schema.COLUMNS where TABLE_SCHEMA = "mixdata" and TABLE_NAME = "tbl_idtc" and COLUMN_NAME = "flag") then
		alter table tbl_idtc add column flag tinyint not null default 0 after idtcTime;
	end if;
	if not exists (select COLUMN_NAME from information_schema.COLUMNS where TABLE_SCHEMA = "mixdata" and TABLE_NAME = "tbl_idtc" and COLUMN_NAME = "extra") then
		alter table tbl_idtc add column extra varchar(256) not null default '' after flag;
	end if;
	
	# tbl_account �û���
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
	# ���⴦��
	update tbl_cloth_info set path=concat(concat(uid, '/Cloth/'),path) where path != '' and path not like '%Cloth/%';
	update tbl_account set head=concat(concat(uid, '/HeadImg/'),head) where head != '' and head not like '%HeadImg/%';
	# ȥ�� tbl_tag_info ���� (uid, cid) ��Ψһ���ԡ�
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
