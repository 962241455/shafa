<?php
//*
// 支付宝 app 相关配置
$appConfig = array(
	'appID' => "2017090408549608",
	'gatewayUrl' => "https://openapi.alipay.com/gateway.do",
	'appSecKey' => "MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC1bu/H946KnupIVccE+y8eQqaiyKo0rwEKaSikV8tW81oIqgsQfRjNCUVs3NObCDN+qIs008ynmznuKV7j4hYuEiBYqy5B74Mi9BINMUhufFO38lz2kNDFgGPVB2y5FMBVvX07siapnSIjF9NhBT6B19NFSWgLN0GDM3cQxw8V2T4oeo8suxojLrUFF02EFSNQq2qLpxlCoJT9SRzYohh4DpC4RwqzxWtY42uZNn5cpVv1h76XdfS+dUT1ZZNP13XpwAMuHP4ytxZjYR5pP6jUjNTX+uBBra3FYvdhd4pWyVgePuXMSfz59Fi4bdKSojy//UDP46AtbayPuR/psTjbAgMBAAECggEBAKrDjlWEkBmydsm8SkRK8k8l5lbiTSim6nDVBxafN1hQVRZAjYdoZpZcuoY61cNeFbGJivQewMmj1QNu1svfeIbGMsGh5DjU6HVWiUL3drfetqE0MQE0zfqF2/CeO1t7x4crgRpVlAQiTAYBn8b6O5nT/BqDe7TKvhNxtggJgw5IwP/dXbPvhPnlN9TbGkBZ6oxVYAwWOdaZrR9XR/NT9BDJyxZu/kdhAqT8ChXUvxVNTy6JQNRYDSLlV+Cnro4d+Xast26vRd36RdKZal0IQla70JMO9MxUQnzc0EWp7YrNzvw/NqILaewBuUB+qJlNypWcfcOoIa+tmliCKERT8fECgYEA8N0FcskMQYFVWCeCmPyAJG12x0UcnfxsMqjVWJUhPKKpTjaD5E4CdaDioLuW3Suc/4h9aVQ/3EwLvyk/suTazUqdBexAv1HMB9Ab6JJDugHWaMvA4dY+55+ysbvBRBmeByLyu1M5E9N8wG2Hl8v0L6NCiv/kWpJm1yRom1QCT6kCgYEAwNXQGlJBUkluaXHVEi2cth2v6DFWD10/s/ccgrMaodn6Xt1XaA+uE19RUtp5Zdv8+7JX91XxH+anlRIE72niivpTRMsiosDcbqmV1EDHnhA5C7qvMHITt96uPwWC7kV0r3QebB3LJBg0R+fKq+mAxs4m/Rz7CYb+Apgfab41puMCgYBYBJyyFpAY+/dBEKcj2tnE9g96wGG1xgGP/ayBA3Yy30o5X6iQ7ITvkUxf6k02I3Lq2mjh7bysd0mvoJY7fHAMpyB8gpoij/ScQkuAkLqZJYTBpPumS5GPOQem9XKpvSbHetjy5XWtLhKfiycKrKheJC3z95DuHCPiqNZlNKzniQKBgAwLz0o1pTr8t1cC82qFSurdg+WfX17qVlZps3A+vAUsVsWiUhmAEUHIjI3+c+L3ESCwDWq4Ba4WfJWFYKWMGcjQxm7fubQtFBgdo+x0d4PaQ5YF/XerSKwNzxjEwV8dG6LyQAxE+DGzCWEMi86dcZv5uNnK+6umsSt8UUoLxdI9AoGASup68l7I/nVgZn2qJPJ7wIsqW80OU5eVgZxuOuI8ver/zCEcHKEQR8xWfqlEucaKplBFJFzjJYdmIYJL5aX75fm424oVNNrs7Z4q+IXVxmHNevVyqSb/FXkJ7jMyZXyos5kPDyBwM2Xp/Ty94HmEAwfb45fAaxXBmj8Ed1/BF3U=",
	'appPubKey' => "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtW7vx/eOip7qSFXHBPsvHkKmosiqNK8BCmkopFfLVvNaCKoLEH0YzQlFbNzTmwgzfqiLNNPMp5s57ile4+IWLhIgWKsuQe+DIvQSDTFIbnxTt/Jc9pDQxYBj1QdsuRTAVb19O7ImqZ0iIxfTYQU+gdfTRUloCzdBgzN3EMcPFdk+KHqPLLsaIy61BRdNhBUjUKtqi6cZQqCU/Ukc2KIYeA6QuEcKs8VrWONrmTZ+XKVb9Ye+l3X0vnVE9WWTT9d16cADLhz+MrcWY2EeaT+o1IzU1/rgQa2txWL3YXeKVslYHj7lzEn8+fRYuG3SkqI8v/1Az+OgLW2sj7kf6bE42wIDAQAB",
	'aliPubKey' => "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAsGeKzaM1T6FOrg7Xx9DmJTIl0ly53a+45/F+7V3X6Z6hjjMgqZv27uCeM/BvfmDZqduJzvnTsHXUlUrJCagp2WT/5A9Fab1TCYnYZYTw2uww6UewA7k09ObynU9jBmgUsABy5vsDVTRqGl6FiEp+1yAuBW/fEFgCZnS8yPxxmBRJkqjznOF6OysYUJslO4b17Y2Dz7HH3ROI1TpWYeI6KhUq7av/bRxeygYuDiRVFsrdR+Q/y/Hqe8VDGRR6Q5j/2QK34CkmCvS2saVZWn7K9XBiDXBPp0KpJDVenwwx3umudcDvSLJLPlUSXdH4OsIcuL46UIM/2u8dd2MbeTVZ1QIDAQAB",

	//'notifyUrl' => "http://118.122.117.61:9101/apis/alipaycb", // 已经无用
	'timeout_express' => "10m", 	// m, h, d, c
	//最大查询重试次数
	'MaxQueryRetry' => "10",
	//查询间隔
	'QueryDuration' => "3"
	);
//*/
/*
// 支付宝 沙箱版 app 相关配置
$appConfig = array(
	'appID' => "2016082000294897",
	'gatewayUrl' => "https://openapi.alipaydev.com/gateway.do",
	'appSecKey' => "MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCeSuPmWapt4tU7OEbGdd5lQ+kB/DotvYrd/s2lwmpPzX+GGlcfnjgwkWDAb1PQrJ8T1vzdBy2LjtK3RAVqf96sR/2MimJZuVNmtE6KQgBmi1hov0588e4PQU6O9egjAyR+TXa2ArUy+MB68GInpefvs6YXnhLlvvGvNvD+yHN6JV1GWHW2uJSI9PD7/vYJ6LCIBzzn7giSDEG12KYCJJsz+8XedYN7BBcoBcDkGW1MwAst0c79bSjNzyjh/R8a4tshe3ejnH6b06YJ0NiqkjUixlhslwZ3hRT7B0oghacGCWYj4AHxEcpVNb0tKf88gklqvgUC8agdVS/kJnfNniFRAgMBAAECggEASby3Nznzw2aUUBbiGVcU93VQGMWnUGFoTAuDPsE3Bt/ClPS2OxtYL3+5Y0s47w9Kt1JBzrCmTcmFbSu5nifc0cJjYVGhiQxkxoYdxBgE2b/1ui3L4TZN4Dta3gu9THoNSOzK7PSL9iecemh6QN/vEGFOcNgJE48ERMvCLd2wtWfw4yacF1KKNF3gOtxw7z/h5wsfrjbmGTOxDBxkthi5TXDRNvL/o+yx5n0Wr5Ri96OdHCwEI89pTsF6b/lZe1C0KU/myYvtZaUNMvcHI7bEz1+p4LKQpHznqZEni9+AcZ1T+OFW6wy0/2y8nDIou5rWmG9s6rNAGQy+gmQrHhcvQQKBgQDKlAMdRngH3Te3veHW9Wgsh8bN4BMEpLF8OFFGuGO/EzBg6UGfnX/UUQg1G/xTvyb/tOgFUZWVJ5/6NqYVTYvH1nH1JspVhIcftria2wbQ5blJzszngo2Sv6M9XXiIXKR7Dux+WlPOQzuMaENiYNgQKoTJ+9xWd1c7LI6ZSkM3eQKBgQDICStMdvA+7hFKk93HfxdcTgbWE668yLQVPwc39MV38g2Ktg7uLhkjYECT9/xXcjByUmf2GVOYy+Mdt+2po+5e0ibVNwGDg97G6MpKDBrpsSkfA+u8RJLqVWmXeWBIwXqsdRiuG7jYDbP0GdBkTvXZus1bYLStl7I0jfqWSXFKmQKBgEoPwvO5B7kYT36FlUOZhPSCz1QFT+6qp5janhxU3WLGCTHlFXDdjBZ7aZzBFocno4JpCUqogR9+1SYNRLsVFr2A0TjnbaHGSgB2NReoa92DnzI0wQUC3e+A0JVmzuJLvHahBiVLsMgAHI1AsSIOde+zG8kco3mZN/MSXy/7zodBAoGAfF4HB5FjKR0GryFj3+bKdV8lrO+r0j/Ohu8a49VQ+JQLi1RJ0BflFTOAsv6ZaxzZtho5/K4eZX9OA2oZX0FGsLlj32hFjqjsVyrgqk0AZo75DAl6BSF1XjAgaEbUcCeqx5I99/HQaLOMUJXEFLlq7SXRC6ECdHM+HqKvS8T5pPECgYEAry/u6xL3HxAePKiNx3TgWcC3/NsWUJnC9TSrAnj534vzUDlH/8Vwb3iBnbCactnbK8R7mv4aaCAN2JI+2yVI8G4Z5PEKU79N97L7cSJrXjZpHZ/T6ZhF+qm49vpvBNSGluzXTt3h31YzE7BVsF6rrluqyYQJcNaS6Kxqkr55VfA=",
	'appPubKey' => "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAnkrj5lmqbeLVOzhGxnXeZUPpAfw6Lb2K3f7NpcJqT81/hhpXH544MJFgwG9T0KyfE9b83Qcti47St0QFan/erEf9jIpiWblTZrROikIAZotYaL9OfPHuD0FOjvXoIwMkfk12tgK1MvjAevBiJ6Xn77OmF54S5b7xrzbw/shzeiVdRlh1triUiPTw+/72CeiwiAc85+4IkgxBtdimAiSbM/vF3nWDewQXKAXA5BltTMALLdHO/W0ozc8o4f0fGuLbIXt3o5x+m9OmCdDYqpI1IsZYbJcGd4UU+wdKIIWnBglmI+AB8RHKVTW9LSn/PIJJar4FAvGoHVUv5CZ3zZ4hUQIDAQAB",
	'aliPubKey' => "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA99NDyl/02xaDJwjVBdSaWgo9TCgmrcTuS86g8M0HG+UMfzll37EgJKizT4UCmlRv6EBTSiScLoDKDGUOOR56j5dTRKAzRJ9aYphLcJr1vyInWSvQd/BjlY9wiGj+1Kso9Ut8AE1IhDZpzE25Snz3efXeEoUr6ALzbPz8HLgwZ/IWd6eFzlbWqRu8nJX0Mt8OlG6L1ct1s+3AcPIjJIpTLsHmU/jLjjTEBo+jQqXKO1unoQM+GFY+N52/7Xi+sl8xrWSH+mUWnNsGsS9FXfeAxS+NqxW4VP9CwkWLMM2s7o/mlvxYiFGG3zPP1nGnzErot5CN+ZCIDjOfjqkxTghPxwIDAQAB",
	
	'notifyUrl' => "http://118.122.117.61:9101/apis/alipaycb",
	'timeout_express' => "10m", 	// m, h, d, c
	//最大查询重试次数
	'MaxQueryRetry' => "10",
	//查询间隔
	'QueryDuration' => "3"
	);
//*/
// 预下单 二维码支付 公共请求参数
$preReqArgs = array(
	'app_id' => null,
	'notify_url' => null,
	'method' => "alipay.trade.precreate",
	'format' => "json",
	'charset' => "utf-8",
	'sign_type' => "RSA2",
	'version' => "1.0",
	'app_auth_token' => null,
	'sign' => null,
	'timestamp' => null,
	'biz_content' => null
	);

// 预下单 二维码支付 业务请求参数（订单信息 biz_content）
$preBizContent = array(
	'out_trade_no' => "必选",
	'seller_id' => null,
	'total_amount' => 0,
	'discountable_amount' => null,
	'subject' => "必选", 	// "订单标题"
	'body' => null, 		// "订单描述"
	'goods_detail' => null, // 商品详情，数组
	'operator_id' => null,
	'store_id' => null,
	'terminal_id' => null,
	'extend_params' => null,
	'timeout_express' => $appConfig['timeout_express']
	);

// sdk支付 公共请求参数
$sdkReqArgs = array(
	'app_id' => null,
	'notify_url' => null,
	'method' => "alipay.trade.app.pay",
	'format' => "json",
	'charset' => "utf-8",
	'sign_type' => "RSA2",
	'version' => "1.0",
	//'app_auth_token' => null,
	'sign' => null,
	'timestamp' => null,
	'biz_content' => null
	);

// sdk支付 业务请求参数（订单信息 biz_content）
$sdkBizContent = array(
	'out_trade_no' => "必选",
	'total_amount' => 0,
	'product_code' => 'QUICK_MSECURITY_PAY', // 销售产品码，商家和支付宝签约的产品码，为固定值QUICK_MSECURITY_PAY
	'subject' => "必选", 	// "订单标题"
	'body' => null, 		// "订单描述"
	'goods_type' => 0, 	// 虚拟类商品
	'passback_params' => null, // 原样回传参数
	'promo_params' => null, // 优惠参数
	'extend_params' => null,
	'store_id' => null,
	'enable_pay_channels' => null,
	'disable_pay_channels' => null,
	'timeout_express' => $appConfig['timeout_express']
	);

?>