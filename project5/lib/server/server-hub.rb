require_relative './server-game'
require_relative './database/database'

class ServerHub
  
  def initialize(gameServers = 1, menuServers = 1, port = 4222)
    
    # creates the other servers
    @gameServers = []
    (1..servers).each do |num|
      @gameServers.push(GameServer.new(port + num))
    end
    @menuServers = []
    (1..servers).each do |num|
      @menuServers.push(MenuServer.new(port + gameServers + num))
    end
    
    @db = Database.new
    
  end
  
  def connectToGameServer(gameId)
    # check if game is currently checked out to a server
    game = @db.get(:games, gameId)
    serverAddress = game[:checkedOutTo]
    
    # redirect here
    return serverAddress if serverAddress
    
    #else check it out to a new server
    address = selectServer(@gameServers)
    game[:checkedOutTo] = address
    @db.update(:games, game)
  end
  
  def connectToMenuServer
    return selectServer(@menuServers)
  end
  
  # finds the server address of the server with the lowest load
  def selectServer(servers)
    # find server with minimum connections
    min = nil
    server = nil
    servers.each do |serv, i|
      if serv.connections < min || min == nil
        min = serv.connections
        server = serv
      end
    end
    # redirect to server.address
    return server.address
  end
 
  
end