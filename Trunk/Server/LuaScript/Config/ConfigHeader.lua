-- Config Header

-- 服务器配置
require "Config/ServerCfg/ServCfg"
require "Config/MailCfg/MailCfg"

-- 支付配置
_G["PayCfg"] = require("Config/PayConfig/PayCfg")
--print(_G["PayCfg"])
_G["RetCode"] = require("Config/RpcRetCode/RetCode")
--print(_G["RetCode"])
