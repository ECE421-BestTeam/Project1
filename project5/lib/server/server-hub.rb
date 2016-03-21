require_relative './server'
require_relative './database/database'

class ServerHub
  
  def initialize(servers = 1, port = 4222)
    
    # creates the other servers
    @servers = []
    (1..servers).each do |num|
      @servers.push(Server.new(port + num))
    end
    
  end
  
  # forwards connections to the other servers for handling
  # returns the serverAddress
  def handleNewConnection
    # find server with minimum connections
    min = nil
    server = nil
    @servers.each do |serv, i|
      if serv.connections < min || min == nil
        min = serv.connections
        server = serv
      end
    end
    # redirect to server.address
    return server.address
  end
 
  
end