-- Pay Header

CAliPay = class() 	-- 支付宝 支付
CWxPay = class() 	-- 微信 支付

require "Server/ApiModule/ApiPay/CAliPay"
require "Server/ApiModule/ApiPay/CWxPay"
require "Server/ApiModule/ApiPay/ApiPayMgr"
