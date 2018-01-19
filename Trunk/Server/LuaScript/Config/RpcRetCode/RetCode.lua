-- RetCode 返回码定义

function ReadConfig()
	local dir = ngx.config.prefix()
	dir = string.gsub(dir, "\\", "/")
	local tail = string.sub(dir, -1, -1)
	if tail ~= "/" then
		dir = dir .. "/"
	end
	local cfgPath = dir .. "../LuaScript/Config/RpcRetCode/retCode.json"
	--print(cfgPath)
    local fh, err = io.open(cfgPath, "r")
    assert(fh, err)
    fh:seek("set")
    local content = fh:read("*a")
    fh:close()
	--print(content)

	local cfg = TextCode.JsonDecode(content)
    return cfg
end

local cfg = ReadConfig()
return cfg
