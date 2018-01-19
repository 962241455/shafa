-- PayCfg

function ReadConfig()
	local dir = ngx.config.prefix()
	dir = string.gsub(dir, "\\", "/")
	local tail = string.sub(dir, -1, -1)
	if tail ~= "/" then
		dir = dir .. "/"
	end
	local payCfgPath = dir .. "../LuaScript/Config/PayConfig/payCfg.json"
	--print(payCfgPath)
    local fh, err = io.open(payCfgPath, "r")
    assert(fh, err)
    fh:seek("set")
    local content = fh:read("*a")
    fh:close()
	--print(content)

	local cfg = TextCode.JsonDecode(content)
	local product = {}
	for i, v in ipairs(cfg.Product) do 
		product[v.pid] = v
	end

    return cfg, product
end

local PayCfg = {}
PayCfg.PayConfig, PayCfg.ProductCfg = ReadConfig()
return PayCfg
