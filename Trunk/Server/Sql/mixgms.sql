################################################################
# 
# 	GM账户数据
# 
################################################################

drop database if exists mixgms;
create database mixgms;
use	mixgms;

#GM账户信息
create table tbl_gms_account
(
    name 					varchar(32) 				not null, 								# 账号
    pass 					varchar(32) 				not null, 								# 密码
    power 				int unsigned 				not null, 								# 权限
    token 				varchar(32) 				not null default '', 			# 令牌
    date 					datetime            not null, 								# 注册日期
    # 约束
    primary key(name)
)engine=innodb DEFAULT CHARSET=utf8;
