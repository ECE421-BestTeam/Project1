require 'socket'
require_relative './server-game'
require_relative './server-menu'
require_relative './database/database'

class ServerHub
  
  def initialize(gameServers = 1, menuServers = 1, port = 4222)
    
    # creates the other servers
    @gameServers = []
    (1..gameServers).each do |num|
      @gameServers.push(GameServer.new(port + num))
    end
    @menuServers = []
    (1..menuServers).each do |num|
      @menuServers.push(MenuServer.new(port + gameServers + num))
    end
    
    @db = Database.new
    @checkOutSemaphore = Mutex.new 
    
    @continue = true
    @server = TCPServer.open(port)
    puts "listening on #{port}"
    
    loop
  end
  
  def loop
    while @continue
#      client = @server.accept
      th = Thread.start(@server.accept) do |client|
        puts "IN"
        client.puts "ok"
        req = client.gets.chomp
        res = "invalid"
        case req
          when "menu"
            res = connectToMenuServer
          when "newGame"
            res = connectToNewGameServer
          when "existingGame"
            res = connectToExistingGameServer(client)
        end
        client.puts res
        client.close                # Disconnect from the client
      end
    end
  end
  
  def connectToMenuServer
    return selectServer(@menuServers)
  end
  
  def connectToNewGameServer
    return selectServer(@gameServers)
  end
  
  def connectToExistingGameServer(client)
    client.puts "ok" # proceed
    gameId = client.gets.chomp
    
    # ensure we are only trying to check out one game at a time
    @checkOutSemaphore.synchronize {
      # get the requested game
      game = @db.get(:games, gameId)
      if !game # Invalid gameId
        return "invalid"
      end

      # check if game is currently checked out to a server
      serverAddress = game[:checkedOutTo]
      # send there
      return serverAddress if serverAddress

      #else check it out to a new server
      address = selectServer(@gameServers)
      game[:checkedOutTo] = address
      @db.update(:games, game)
      return address
    }
  end
  
  # finds the server address of the server with the lowest load
  def selectServer(servers)
    # find server with minimum connections
    min = nil
    server = nil
    servers.each do |serv|
      if min == nil || serv.connections < min
        min = serv.connections
        server = serv
      end
    end
    # redirect to server.address
    return server.address
  end
 
  
end

#ServerHub.new
