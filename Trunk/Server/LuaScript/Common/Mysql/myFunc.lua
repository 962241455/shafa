-- mysql 实例
function MyFunc:Ctor(host, port, user, password, database, keepTime, connNum)
	self.m_oMysql = nil
	self.host = host
	self.port = port
	self.user = user
	self.password = password
	self.database = database
	self.keepTime = tonumber(keepTime) or 60000
	self.connNum  = tonumber(connNum) or 512
end

function MyFunc:Close()
    if not self.m_oMysql then
        return
    end

    local insMysql = self.m_oMysql
    self.m_oMysql = nil
    insMysql:close()
end

function MyFunc:getInstance()
    if self.m_oMysql then
        return self.m_oMysql
    end
    local ok, err, insMysql = true, nil, nil
    insMysql, err = MyFunc.mysql:new()
    if not insMysql then
        print("1MyFunc:getInstance", err)
        return nil, err
    end
    ok, err = insMysql:connect({host = self.host, port = self.port, 
        user = self.user, password = self.password, database = self.database, 
        max_packet_size = 8 * 1024 * 1024})
    if not ok then
        print("2MyFunc:getInstance", err)
        return nil, err
    end
    self.m_oMysql = insMysql
    return self.m_oMysql
end

function MyFunc:freeInstance()
	if not self.m_oMysql then
		return
	end

    local insMysql = self.m_oMysql
    self.m_oMysql = nil
    insMysql:set_keepalive(self.keepTime, self.connNum)
end

function MyFunc:query(sql, est_nrows)
    if type(sql) ~= 'string' then
        return nil, "sql must be string: " .. tostring(sql)
    end
    local insMysql = self:getInstance()
    local ret, err, errno, sqlstate = insMysql:query(sql, est_nrows)
    if not ret then
        --print("MyFunc:query(): ", err, errno, sqlstate)
        self:freeInstance()
        insMysql = self:getInstance()
        ret, err, errno, sqlstate = insMysql:query(sql, est_nrows)
    end
    --print(ret, err, errno, sqlstate)
    assert(ret, LuaEx.LuaStr({err, errno, sqlstate}))
    return ret, err, errno, sqlstate
end
