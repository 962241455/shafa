use	mixlog;

########################################################
#                       �����±�                       #
########################################################

# ����log�õ������������
create table if not exists tbl_retain_log
(
    guid 					bigint unsigned 	not null auto_increment, 	# ΨһID
    record_time 	int unsigned 			not null, 								# ������¼�����һ�θ��µ�����
    uid 					int unsigned 			not null, 								# �˻�ΨһID
    reg_time 			int unsigned 			not null, 								# ע��ʱ��
    ret2 					tinyint(1) 				not null default 0, 			# ��������2���Ƿ��е�¼��0����1����
    ret3 					tinyint(1) 				not null default 0, 			# ��������3���Ƿ��е�¼��0����1����
    ret7 					tinyint(1) 				not null default 0, 			# ��������7���Ƿ��е�¼��0����1����
    ret30 				tinyint(1) 				not null default 0, 			# ��������30���Ƿ��е�¼��0����1����
    count7 				int unsigned 			not null default 1, 			# ע���7���ڣ���¼��������
    count30 			int unsigned 			not null default 1, 			# ע���30���ڣ���¼��������
    count_total 	int unsigned 			not null default 1, 			# ע��󣬵�¼��������
    primary key(guid)
)engine=innodb DEFAULT CHARSET=utf8;

# ����log�õ������������
create table if not exists tbl_pay_log
(
    guid 					bigint unsigned 	not null auto_increment, 	# ΨһID
    record_time 	int unsigned 			not null, 								# ������¼������
    platID 				int unsigned 			not null, 								# ƽ̨ID��0��û��ƽ̨��1����׿��2��IOS��3��windows
    payway 				tinyint 					not null, 								# ֧����ʽ��֧����(AliPay)��1��΢��(WeiXin)��2��
    pid 					varchar(32) 			not null, 								# ��ƷID����λ
    pay_count 		int unsigned 			not null, 								# ��ֵ����
    user_count 		int unsigned 			not null, 								# ��ֵ����
    total_amount 	int unsigned 			not null, 								# ��ֵ�ܽ��
    primary key(guid)
)engine=innodb DEFAULT CHARSET=utf8;
