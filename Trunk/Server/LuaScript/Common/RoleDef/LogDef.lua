-- LogDef
module("LogDef", package.seeall)

-------------------------------- 事件类型定义 --------------------------------
-- 事件类型枚举：只可增加，不可删除、修改。
EventType = {}
-- 通用：0 - 100 
EventType.None = 0
EventType.Register = 1
EventType.Verify = 2
EventType.Login = 3
-- 充值交易相关 10 - 19
EventType.AddTrade = 11 -- 创建交易订单
EventType.FinishTrade = 12 -- 完成交易订单
EventType.GetAllTrade = 13 -- 获取所有交易订单

-- vip相关 100 - 109
EventType.AddVipTime = 101 -- 增加vip时间
EventType.SubVipTime = 102 -- 减少vip时间
EventType.SetVipTime = 103 -- 设置vip时间

-- 面料、沙发。110 - 139
EventType.Share = 110 -- 分享

EventType.GetAllCloth = 111 -- 同步时，获取所有面料
EventType.AddCloth = 112 -- 同步时，增加面料
EventType.DelCloth = 113 -- 同步时，删除面料
EventType.UpdateCloth = 114 -- 同步时，更新面料
--EventType.DownCloth = 115 -- 同步时，下载面料图片

EventType.GetAllTag = 121 -- 同步时，获取所有标签
EventType.AddTag = 122 -- 同步时，增加标签
EventType.DelTag = 123 -- 同步时，删除标签
EventType.UpdateTag = 124 -- 同步时，更新标签

EventType.GetAllSofa = 131 -- 同步时，获取所有沙发
EventType.AddSofa = 132 -- 同步时，增加沙发
EventType.DelSofa = 133 -- 同步时，删除沙发
EventType.UpdateSofa = 134 -- 同步时，更新沙发

-- 消息邮件系统。140 - 169
EventType.S2CMail = 141 -- 发送到客户端
EventType.C2SMail = 142 -- 发送到服务端
EventType.ReadMail = 143 -- 读取邮件
EventType.RecvMail = 144 -- 领取邮件中的附件奖励

-- 企业账户系统。170 - 199
EventType.UserCreateCom = 171 -- 个人账户创建企业账户
EventType.UserRefuseAuth = 172 -- 个人账户拒绝 企业账户的授权邀请
EventType.UserAcceptAuth = 173 -- 个人账户接受 企业账户的授权邀请
EventType.UserAddApply = 174 -- 个人账户增加一个授权申请
EventType.ComAddAuth = 175 -- 企业账户增加一个授权邀请
EventType.ComRefuseApply = 176 -- 企业账户拒绝 个人账户的授权申请
EventType.ComAcceptApply = 177 -- 企业账户接受 个人账户的授权申请
--EventType.UserQuitAuth = 178 -- 个人账户解除一个授权
EventType.ComDelAuth = 179 -- 企业账户删除一个授权
EventType.ComTransfer = 180 -- 企业账户转让
EventType.ComDismiss = 181 -- 企业账户解散
EventType.ComReunion = 182 -- 企业账户重聚
EventType.UserDataToComData = 190 -- 个人账户(企业主)将数据转移到企业账户中
EventType.ComDataToUserData = 191 -- 企业账户将数据转移到个人账户(企业主)中
