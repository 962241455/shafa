################################################################
# 
# 	�û�����
# 
################################################################

drop database if exists mixlog;
create database mixlog;
use	mixlog;


# Log �¼���¼����ͨlog��¼��
create table tbl_log_normal
(
    guid 					bigint unsigned 	not null auto_increment, 	# ΨһID��long long
    nowTime 			datetime 					not null, 								# ���ݿ�ʱ�� now()
    uid 					int unsigned 			not null, 								# �˻�ΨһID
    eventType 		int unsigned 			not null, 								# �¼�����
    eventReason 	varchar(32) 			not null, 								# �¼�ԭ�򣬰����û�������GM������
    eventTime 		int unsigned 			not null, 								# �¼�ʱ��
    platID 				int unsigned 			not null default 0, 			# ƽ̨ID��0��û��ƽ̨��1����׿��2��IOS��3��windows
    operator 			varchar(32) 			not null default "", 			# ������Ա���п������û���GM_XXX)
    ipAddr 				varchar(32) 			not null default "", 			# ip��ַ
    sVersion 			varchar(16) 			not null default "", 			# ����˰汾��
    cVersion 			varchar(16) 			not null default "", 			# �ͻ��˰汾��
    # ����Ϊ�����ϸ����
    extra 				varbinary(1024) 	not null default '', 			# �������ݡ����ݹ���ʱ���ɼ��벹���
    primary key(guid)
)engine=innodb DEFAULT CHARSET=utf8;


# Log �¼���¼���˺���أ�ע�ᡢ��¼��
# ע�� log ����ɾ������¼ log ���Զ��ڴ���ֻ���浱�����һ�ε�¼log��
create table tbl_log_account
(
    guid 					bigint unsigned 	not null auto_increment, 	# ΨһID��long long
    nowTime 			datetime 					not null, 								# ���ݿ�ʱ�� now()
    uid 					int unsigned 			not null, 								# �˻�ΨһID
    eventType 		int unsigned 			not null, 								# �¼�����
    eventReason 	varchar(32) 			not null, 								# �¼�ԭ�򣬰����û�������GM������
    eventTime 		int unsigned 			not null, 								# �¼�ʱ��
    platID 				int unsigned 			not null default 0, 			# ƽ̨ID��0��û��ƽ̨��1����׿��2��IOS��3��windows
    operator 			varchar(32) 			not null default "", 			# ������Ա���п������û���GM_XXX)
    ipAddr 				varchar(32) 			not null default "", 			# ip��ַ
    sVersion 			varchar(16) 			not null default "", 			# ����˰汾��
    cVersion 			varchar(16) 			not null default "", 			# �ͻ��˰汾��
    # ����Ϊ�����ϸ����
    location 			varchar(64) 			not null default "", 			# ����λ�á�
    primary key(guid)
)engine=innodb DEFAULT CHARSET=utf8;


# Log �¼���¼����ֵ��أ���ֵ���˿
# ��ֵ���˿� log ����ɾ����
create table tbl_log_charge
(
    guid 					bigint unsigned 	not null auto_increment, 	# ΨһID
    nowTime 			datetime 					not null, 								# ���ݿ�ʱ�� now()
    uid 					int unsigned 			not null, 								# �˻�ΨһID
    eventType 		int unsigned 			not null, 								# �¼�����
    eventReason 	varchar(32) 			not null, 								# �¼�ԭ�򣬰����û�������GM���������ߵ�����(alipay��wxpay)
    eventTime 		int unsigned 			not null, 								# �¼�ʱ��
    platID 				int unsigned 			not null default 0, 			# ƽ̨ID��0��û��ƽ̨��1����׿��2��IOS��3��windows
    operator 			varchar(32) 			not null default "", 			# ������Ա���п������û���GM_XXX)
    ipAddr 				varchar(32) 			not null default "", 			# ip��ַ
    sVersion 			varchar(16) 			not null default "", 			# ����˰汾��
    cVersion 			varchar(16) 			not null default "", 			# �ͻ��˰汾��
    # ����Ϊ�����ϸ����
    tradeno 			varchar(32) 			not null, 			# ������
    createTime 		int unsigned 			not null, 			# ��������ʱ��
    pid 					varchar(32) 			not null, 			# ��ƷID����λ
    amount 				double 						not null, 			# ʵ��֧�����
    payway 				tinyint 					not null, 			# ֧����ʽ��֧����(AliPay)��1��΢��(WeiXin)��2��
    paymod 				tinyint 					not null, 			# ֧��ģʽ����ά��(QR)��1��SDK��2��
    primary key(guid)
)engine=innodb DEFAULT CHARSET=utf8;

# ����log�õ������������
create table tbl_retain_log
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
create table tbl_pay_log
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
