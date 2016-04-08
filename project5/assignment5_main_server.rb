require_relative './lib/server/server'

# starts a server
s = Server.new
s.start
while true
	sleep 100000
end