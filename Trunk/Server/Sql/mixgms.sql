################################################################
# 
# 	GM�˻�����
# 
################################################################

drop database if exists mixgms;
create database mixgms;
use	mixgms;

#GM�˻���Ϣ
create table tbl_gms_account
(
    name 					varchar(32) 				not null, 								# �˺�
    pass 					varchar(32) 				not null, 								# ����
    power 				int unsigned 				not null, 								# Ȩ��
    token 				varchar(32) 				not null default '', 			# ����
    date 					datetime            not null, 								# ע������
    # Լ��
    primary key(name)
)engine=innodb DEFAULT CHARSET=utf8;
