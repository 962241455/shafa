################################################################
# 
# 	�û�����
# 
################################################################

drop database if exists mixdata;
create database mixdata;
use	mixdata;

# ����һ���ձ�insert into ... select ... ������ʱ����Ҫ�õ����� 
create table empty
(
    id 				tinyint				not null default 0,
    primary key(id)
)engine=innodb DEFAULT CHARSET=utf8;
insert into empty(id) values(0);
# insert into tbl_test1(guid, name) select '1', '1' from empty where not exists(select * from tbl_test1 where guid = '1');

#������֤��
create table tbl_idtc
(
    phno 				varchar(32) 				not null, 								# �绰����
    idtc 				varchar(16) 				not null default '', 			# �ֻ���֤��
    idtcTime 		int unsigned 				not null default 0, 			# �ֻ���֤������ʱ��
    flag 				tinyint 						not null default 0, 			# �Ƿ�ʹ�õı�־��0����ʾδ��ʹ�ã�1����ʾ�Ѿ���ʹ�á�
    extra				varchar(256) 				not null default '', 			# ����ƽ̨���صĶ�������
    primary key(phno)
)engine=innodb DEFAULT CHARSET=utf8;

#�˻���Ϣ
create table tbl_account
(
    uid 					int unsigned				not null auto_increment, 	# �˻�ΨһID
    user 					varchar(32) 				not null, 								# �˺ţ��绰����
    pass 					varchar(32) 				not null, 								# ����
    type 					tinyint 						not null, 								# �˺����͡�0�������˻���1����ҵ�˻���2����ҵ���˻�(�����˻�)��10���ο��˻���
    status 				tinyint 						not null default 0,				# �˺�״̬��0������״̬��1��ɾ��״̬��
    owner_uid 		int unsigned				not null default 0,				# ��ҵ�˻�����ҵ���˻� ��ӵ���ߵ�uid��
    com_cnt 			int unsigned				not null default 0,				# ������ҵ�˻��Ĵ�����
    date 					datetime            not null, 								# ע������
    userip 				varchar(64) 				not null default '', 			# ע��ʱ IP
    location 			varchar(64) 				not null default '', 			# ע��ʱ ����λ��
    nick 					varchar(64) 				not null default '', 			# �ǳ�
    head 					varchar(64) 				not null default '',			# ͷ��ͼƬ�ļ�·����
    token 				varchar(32) 				not null default '', 			# ����
    tokenTime 		int unsigned 				not null default 0, 			# ������Чʱ��
    # vip ���
    total_amount 	double 							not null default 0, 			# ��ֵ�ܶ�
    expire_time 	int unsigned 				not null default 0, 			# ��Ա����ʱ��
    # Լ��
    CONSTRAINT uq_user UNIQUE (user),
    primary key(uid)
)engine=innodb DEFAULT CHARSET=utf8;
alter table tbl_account AUTO_INCREMENT=1000001;

#��ҵ�˻���Ȩ�����˻�
create table tbl_account_auth
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

#֧�����
create table tbl_pay
(
    trade_no 		varchar(32) 				not null, 						# ������
    type 				tinyint 						not null, 						# ���ͣ������ֶΡ�
    uid 				int unsigned				not null, 						# �˻�ID
		pid 				varchar(32) 				not null, 						# ��ƷID
    statu 			tinyint 						not null default 0, 	# 0����ʾ�ȴ����1����ʾ�Ѿ����������ɣ�2���Ѿ�ʧЧ���ڡ�
    amount			double 							not null, 						# ���
    add_time 		int unsigned				not null, 						# ���ӻ�Աʱ�䣬��λ��
    cre_time 		int unsigned 				not null default 0, 	# ����ʱ��
    done_time 	int unsigned 				not null default 0, 	# ���ʱ��
    extra				varchar(256) 				not null default '', 	# ������֧�����صĶ�������
    CONSTRAINT fk_p_uid foreign key(uid) references tbl_account(uid) on delete cascade on update cascade,
    primary key(trade_no)
)engine=innodb DEFAULT CHARSET=utf8;

#�û�������Ϣ
create table tbl_cloth_info
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
create table tbl_tag_info
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
create table tbl_sofa_info
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
create table tbl_mail
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
create table tbl_mail_status
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
