-- 服务端入口
local args = ngx.req.get_query_args()
ngx.req.read_body()
local body = ngx.req.get_body_data()
local bodyFile = nil
if not body then
	bodyFile = ngx.req.get_body_file()
end
-- 接受客户端的请求并处理
Rpc.Recv(args, body, bodyFile)
