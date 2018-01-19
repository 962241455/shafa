-- TextCode 文本编码
module("TextCode", package.seeall)

local gJson = require('cjson')
local gSha256 = require "resty.sha256"
local gAes = require "resty.aes"
local gRSA = require "resty.rsa"

-- 2进制数据转换为16进制字符串
function Bin2HexStr(bin)
	--local s, cnt = string.gsub(bin, "(.)", function (x) return string.format("%02x",string.byte(x)) end)
	return string.gsub(bin, "(.)", function (x) return string.format("%02x",string.byte(x)) end)
end

function JsonEncode(data)
	return gJson.encode(data)
end

function JsonDecode(data)
	return gJson.decode(data)
end

function Base64Encode(data)
	return ngx.encode_base64(data)
end

function Base64Decode(data)
	return ngx.decode_base64(data)
end

function Md5Encode(data)
    return ngx.md5(data)
end

function Sha256Encode(data)
	local o = gSha256:new()
	o:update(data)
	local ret = o:final()
	return Bin2HexStr(ret)
end

function HmacSha1Encode(key, data)
    return ngx.hmac_sha1(key, data)
end

function Sha1Encode(data)
	local ret = ngx.sha1_bin(data)
	return Bin2HexStr(ret)
end


function RsaGenKey()
    local rsa_public_key, rsa_priv_key, err = gRSA:generate_rsa_keys(2048)
    return rsa_public_key, rsa_priv_key, err
end

-- 检查RSA参数
function RsaOptCheck(opt)
	if not opt then
		return nil
	end
	local t = {}
	if opt.public_key then
		t.public_key = opt.public_key
	end
	if opt.private_key then
		t.private_key = opt.private_key
	end
	if opt.key_type then
		t.key_type = opt.key_type
	end
	if opt.padding then
		t.padding = opt.padding
	end
	if opt.algorithm then
		t.algorithm = opt.algorithm
	end
	return t
end

-- 加密。 opt = { public_key = key, key_type == gRSA.KEY_TYPE.PKCS8, padding = gRSA.PADDING.RSA_NO_PADDING }
function RsaEncode(opt, data)
	opt = RsaOptCheck(opt)
	if not opt or not next(opt) then
		return data
	end
	local o, err = gRSA:new(opt)
	if not o then
		return nil, err
	end
    return o:encrypt(data)
end

-- 解密。 opt = { private_key = key, key_type == gRSA.KEY_TYPE.PKCS8, padding = gRSA.PADDING.RSA_NO_PADDING }
function RsaDecode(opt, data)
	opt = RsaOptCheck(opt)
	if not opt or not next(opt) then
		return data
	end
	local o, err = gRSA:new(opt)
	if not o then
		return nil, err
	end
    return o:decrypt(data)
end

-- 加签。 opt = { private_key = key, algorithm = "SHA1" }
function RsaSign(opt, data)
	opt = RsaOptCheck(opt)
	opt.algorithm = opt.algorithm or "SHA256"
	local o, err = gRSA:new(opt)
	if not o then
		return nil, err
	end
    return o:sign(data)
end

-- 验签。 opt = { public_key = key, algorithm = "SHA1" }
function RsaVerify(opt, data, sign)
	opt = RsaOptCheck(opt)
	opt.algorithm = opt.algorithm or "SHA256"
	local o, err = gRSA:new(opt)
	if not o then
		return nil, err
	end
    return o:verify(data, sign)
end





--[[

function AesEncode(key, data)
	local o = gAes:new(key, salt, _cipher, _hash, hash_rounds)
	return o:encrypt(data)
end

function AesDecode(key, data)
	local o = gAes:new(key, salt, _cipher, _hash, hash_rounds)
	return o:decrypt(data)
end



-- 每隔 count 个字符，就插入一个 replace 字符串
function WordWrap(data, count, replace)
	if type(data) == 'string' and string.len(data) > 0 and 
		type(replace) == 'string' and string.len(replace) > 0 and count > 0 then
		-- 
		local res, pos, len = "", -1, string.len(data)
		for i = 1, len, count do
			pos = i + count - 1
			if pos < len then
				res = res .. string.sub(data, i, pos) .. replace
			else
				res = res .. string.sub(data, i, len)
			end
		end
		return res
	else
		return data
	end
end
function ForPubKey(pubKey)
	if type(pubKey) ~= 'string' or string.len(pubKey) <= 0 then
		return pubKey
	end
	local res = "-----BEGIN RSA PUBLIC KEY-----\n" .. WordWrap(pubKey, 64, '\n') .. "\n-----END RSA PUBLIC KEY-----"
	return res
end
function ForPriKey(priKey)
	if type(priKey) ~= 'string' or string.len(priKey) <= 0 then
		return priKey
	end
	local res =  "-----BEGIN RSA PRIVATE KEY-----\n" .. WordWrap(priKey, 64, '\n') .. "\n-----END RSA PRIVATE KEY-----"
	return res
end
function RsaTest()
	local appConfig = {}
	appConfig.appSecKey = "MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCeSuPmWapt4tU7OEbGdd5lQ+kB/DotvYrd/s2lwmpPzX+GGlcfnjgwkWDAb1PQrJ8T1vzdBy2LjtK3RAVqf96sR/2MimJZuVNmtE6KQgBmi1hov0588e4PQU6O9egjAyR+TXa2ArUy+MB68GInpefvs6YXnhLlvvGvNvD+yHN6JV1GWHW2uJSI9PD7/vYJ6LCIBzzn7giSDEG12KYCJJsz+8XedYN7BBcoBcDkGW1MwAst0c79bSjNzyjh/R8a4tshe3ejnH6b06YJ0NiqkjUixlhslwZ3hRT7B0oghacGCWYj4AHxEcpVNb0tKf88gklqvgUC8agdVS/kJnfNniFRAgMBAAECggEASby3Nznzw2aUUBbiGVcU93VQGMWnUGFoTAuDPsE3Bt/ClPS2OxtYL3+5Y0s47w9Kt1JBzrCmTcmFbSu5nifc0cJjYVGhiQxkxoYdxBgE2b/1ui3L4TZN4Dta3gu9THoNSOzK7PSL9iecemh6QN/vEGFOcNgJE48ERMvCLd2wtWfw4yacF1KKNF3gOtxw7z/h5wsfrjbmGTOxDBxkthi5TXDRNvL/o+yx5n0Wr5Ri96OdHCwEI89pTsF6b/lZe1C0KU/myYvtZaUNMvcHI7bEz1+p4LKQpHznqZEni9+AcZ1T+OFW6wy0/2y8nDIou5rWmG9s6rNAGQy+gmQrHhcvQQKBgQDKlAMdRngH3Te3veHW9Wgsh8bN4BMEpLF8OFFGuGO/EzBg6UGfnX/UUQg1G/xTvyb/tOgFUZWVJ5/6NqYVTYvH1nH1JspVhIcftria2wbQ5blJzszngo2Sv6M9XXiIXKR7Dux+WlPOQzuMaENiYNgQKoTJ+9xWd1c7LI6ZSkM3eQKBgQDICStMdvA+7hFKk93HfxdcTgbWE668yLQVPwc39MV38g2Ktg7uLhkjYECT9/xXcjByUmf2GVOYy+Mdt+2po+5e0ibVNwGDg97G6MpKDBrpsSkfA+u8RJLqVWmXeWBIwXqsdRiuG7jYDbP0GdBkTvXZus1bYLStl7I0jfqWSXFKmQKBgEoPwvO5B7kYT36FlUOZhPSCz1QFT+6qp5janhxU3WLGCTHlFXDdjBZ7aZzBFocno4JpCUqogR9+1SYNRLsVFr2A0TjnbaHGSgB2NReoa92DnzI0wQUC3e+A0JVmzuJLvHahBiVLsMgAHI1AsSIOde+zG8kco3mZN/MSXy/7zodBAoGAfF4HB5FjKR0GryFj3+bKdV8lrO+r0j/Ohu8a49VQ+JQLi1RJ0BflFTOAsv6ZaxzZtho5/K4eZX9OA2oZX0FGsLlj32hFjqjsVyrgqk0AZo75DAl6BSF1XjAgaEbUcCeqx5I99/HQaLOMUJXEFLlq7SXRC6ECdHM+HqKvS8T5pPECgYEAry/u6xL3HxAePKiNx3TgWcC3/NsWUJnC9TSrAnj534vzUDlH/8Vwb3iBnbCactnbK8R7mv4aaCAN2JI+2yVI8G4Z5PEKU79N97L7cSJrXjZpHZ/T6ZhF+qm49vpvBNSGluzXTt3h31YzE7BVsF6rrluqyYQJcNaS6Kxqkr55VfA="
	appConfig.appPubKey = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAnkrj5lmqbeLVOzhGxnXeZUPpAfw6Lb2K3f7NpcJqT81/hhpXH544MJFgwG9T0KyfE9b83Qcti47St0QFan/erEf9jIpiWblTZrROikIAZotYaL9OfPHuD0FOjvXoIwMkfk12tgK1MvjAevBiJ6Xn77OmF54S5b7xrzbw/shzeiVdRlh1triUiPTw+/72CeiwiAc85+4IkgxBtdimAiSbM/vF3nWDewQXKAXA5BltTMALLdHO/W0ozc8o4f0fGuLbIXt3o5x+m9OmCdDYqpI1IsZYbJcGd4UU+wdKIIWnBglmI+AB8RHKVTW9LSn/PIJJar4FAvGoHVUv5CZ3zZ4hUQIDAQAB"
	appConfig.aliPubKey = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA99NDyl/02xaDJwjVBdSaWgo9TCgmrcTuS86g8M0HG+UMfzll37EgJKizT4UCmlRv6EBTSiScLoDKDGUOOR56j5dTRKAzRJ9aYphLcJr1vyInWSvQd/BjlY9wiGj+1Kso9Ut8AE1IhDZpzE25Snz3efXeEoUr6ALzbPz8HLgwZ/IWd6eFzlbWqRu8nJX0Mt8OlG6L1ct1s+3AcPIjJIpTLsHmU/jLjjTEBo+jQqXKO1unoQM+GFY+N52/7Xi+sl8xrWSH+mUWnNsGsS9FXfeAxS+NqxW4VP9CwkWLMM2s7o/mlvxYiFGG3zPP1nGnzErot5CN+ZCIDjOfjqkxTghPxwIDAQAB"
	appConfig.tttPriKey = "MIIEpQIBAAKCAQEA69zy8YjJRzpAB1Sn+Qi5h9lq2WUU/TaxQeJ4iqkrzX3Yf5AM+lFUGaALVI5ZmjhpHWkeJeEsWXhM+pz6PSlgfJrPx3Qm82l9J22sGTNbADmKLAejGo7xd12K1S4GhAeCWo/sAjArQFMopQOjmYwzFoqG5gMCWzfDfCmaAdMiF4jpwhr0jvi/kUKY677C1yYKTB6QVxQIKoVZPZycFaPtr28n5qq+Y0n6pZ5w8WPbY6OkiGe65xgF6IeF2/y+OKC9aKqVkNgfDTvqOlXBwNgcrb/pUlc3aFV1BJW/2CLotpi7bNs3g0AZWiSgMFQxN3xwvvFVHoIJlvTFWoTnSdG+rwIDAQABAoIBAQCXsA1+UN5BtLChBkzQ2E+ZkrYpAd0xzA7LtH6ZjprhGWI3B8mQ4uUXZdpjkvkFOepAQ+5jpiEDmV7IflRhKU8oU9f1CjpSqTEYPmxD+Mc5qce28WJwHiYlAj/bQjJmjv3CiHTcI2ZthA3Lsj9w7L2ebZC8NIs7Zu2N2KN3MPXn86U7BOzQqISTY7PqxFrlcUCOfkKu9nBkimnzdb7G7cl+jP59gGl5tVM+iR+8BCdMDOTeNRIqueVoBj5KTA5Ms/O9pJUD3cVPro4+aD9SdaHBNkuBHOBgwluSQFw/ouZPmLdL5ETHv7NBsqbmixPXcRMaAhNj3f1dpMe964UdDlhBAoGBAP7tVess5s6bgfHwNqGbGqRyGUB63mAk3CpbgDewslgpqMHSkXEPt3B7h0yUL6MR02abAX6oQFcGvNdq1bGO9O+4H/DFx9iSaaAqJM83ua3R+4D1pB3ufVt5LFpkldfASg9DbP2AKM2MeNmQ43BVzACySGg6KSXGIO4idXosXWKHAoGBAOzbEshiKL9AlJvpxSyFXfD34wxidXW2cOZmG/1m+ydjxUyT2bP8VcuqXhhOgYgtWFCEy8/XRWZr7+mALVac+arXJRjsFpv3XDPHUHjljo4DGd/TbbouAHPMThK5y0ZZH1PebvnGbDCoMiyPDamdm6yM6GaNHlrdeOtLegpA+kSZAoGAVw3dRU40E2HvYhtRzKYW1wlPrkFHJzXvKVfN1Ta18H1pb6bkm+NuFS9Z6MDB88Hmmydbv1Ddh9p5KmcFSnkzE5mg7qvbrw1wnI1HvKue8MjARi2cOcxzaoVarBOlR+QWZlf0JC1bwbWynzlnMblazPIU3+LcolWicS+7RllYGokCgYEA3CtockyMg/uMKMJNPu1aPbyvmbuMZDeLCyCvtAYeQKdFp8FoBR7ywbdEcGPJlMRR68cFjdYV9PcwtGUpv/F7Q4tqOJh9C84MLzV/YGJC+U94pc7rmL1aPkoT6OQ8SNBfhp6lmhkQSMqQmUsA8EJJi0QQZAOZy+1DkbU/ZHiyK0ECgYEAtXKj+kDulCBQqQWpWmH8qw+pRlgmjeVjEfD6+jG43HeU0a6W5eTl/X2KX/ufEPEPzgJ0z7gx9gae21o/fjitGU9965NnCs0LIjCKBnsDSYCh3PlPSM7UMeglEBJ9sKOBRDdCgOU0U2Kcl8l2JndOkZTeH7lx0dCcs42z+winWwo="
	appConfig.tttPubKey = "MIIBCgKCAQEA69zy8YjJRzpAB1Sn+Qi5h9lq2WUU/TaxQeJ4iqkrzX3Yf5AM+lFUGaALVI5ZmjhpHWkeJeEsWXhM+pz6PSlgfJrPx3Qm82l9J22sGTNbADmKLAejGo7xd12K1S4GhAeCWo/sAjArQFMopQOjmYwzFoqG5gMCWzfDfCmaAdMiF4jpwhr0jvi/kUKY677C1yYKTB6QVxQIKoVZPZycFaPtr28n5qq+Y0n6pZ5w8WPbY6OkiGe65xgF6IeF2/y+OKC9aKqVkNgfDTvqOlXBwNgcrb/pUlc3aFV1BJW/2CLotpi7bNs3g0AZWiSgMFQxN3xwvvFVHoIJlvTFWoTnSdG+rwIDAQAB"

	local pubKey, priKey, err = RsaGenKey()
	print("1: ", string.len(priKey), " , ", string.len(pubKey))

	local data = "This is a test!"
	local opt1 = { private_key = ForPriKey(appConfig.tttPriKey), algorithm = "SHA256" }
	local opt2 = { public_key  = ForPubKey(appConfig.tttPubKey), algorithm = "SHA256" }
	local sign    = RsaSign(opt1, data)
	local ok, err = RsaVerify(opt2, data, sign)
	print("2: ", ok or err)
	print("3: ", string.len(opt1.private_key), " , ", string.len(opt2.public_key))

	local opt1 = { private_key = ForPriKey(appConfig.appSecKey), algorithm = "SHA256" }
	local opt2 = { public_key  = ForPubKey(appConfig.appPubKey), algorithm = "SHA256" }
	local sign    = RsaSign(opt1, data)
	local ok, err = RsaVerify(opt2, data, sign)
	print("4: ", ok or err)
	print("5: ", string.len(opt1.private_key), " , ", string.len(opt2.public_key))
end
RsaTest()




local jsonTest = {}
jsonTest["name"] = "heheda"
jsonTest["type"] = 1
jsonTest["flag"] = true
jsonTest["prg"]  = 3.1415926
local str = JsonEncode(jsonTest)
print(str)
local ret = JsonDecode(str)
for i,v in ipairs(ret) do
	print(i,v)
end



local test = {}
test[""] = "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
test["abc"] = "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad"
test["abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq"] = "248d6a61d20638b8e5c026930c3e6039a33ce45964ff2167f6ecedd419db06c1"
test["abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmnhijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu"] = "cf5b16a778af8380036ce59e7b0492370b249b11e8f07a51afac45037afee9d1"

for k,v in pairs(test) do
	local message = k;
	local expected = v;
	local actual = Sha256Encode(message)
	if actual ~= expected then
		assert(false, "==========error")
	end
	print(string.format("message(%s) expected(%s) actual(%s)", message, expected, actual))
end
--]]