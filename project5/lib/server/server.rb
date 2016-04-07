require 'socket'
require 'xmlrpc/client'
require 'xmlrpc/server'
require_relative './database/database'
require_relative '../common/model/game'

# a server for all things connect4.2
class Server
  
  attr_reader :address
  
  # time out is how long before a client is deemed inactive
  def initialize(port = 50500, timeout = 60 * 60)
    @port = port
    @timeout = timeout # default is an hour
    
#    @db = Database.new
    
    # Hash of all current games.
#    {
#      :gameID1 => {
#        :game => gameObject
#        :players => {
#          :sessId1 => client1Address
#          :sessId2 => client2Address
#        }
#      }
#    }
    @games = {}
    
    startServer
    
  end
  
  # Starts the server and registers all it's handlers
  def startServer
    
    while true
      begin
        @server = XMLRPC::Server.new(@port)
        break
      end
      @port += 1
      if @port > 50550
        raise IOError, "Can not start Server."
      end
    end
    
    @address = "#{local_ip}:#{@port}"
    puts "listening on #{address}"
    games = @db.registerServer(address)
    
    # Recovery if server went down
    games.each do |game|
      
    end
    
    menuFunctions
    
    boardFunctions    

    @server.serve
  end
  
  def menuFunctions
    
    # attempts to create a player
    # returns the session id on success
    @server.add_handler('createPlayer') do |username, password|
      getResult(Proc.new {
        @db.createPlayer(username, password)
      })
    end
     
    # attempts to login a client, will create a session on success
    # returns the session id on success
    @server.add_handler('login') do |username, password|
      getResult(Proc.new {
        @db.checkLogin(username, password)
      })
    end
    
    # attempts to logout a client
    @server.add_handler('logout') do |sessionId|
      getResult(Proc.new {
        @db.logout(sessionId)
      })
    end
    
    #returns a list of games
    @server.add_handler('getGames') do |sessionId|
      getResult(Proc.new {
        @db.getPlayerGames(sessionId)
      }) 
    end
    
    @server.add_handler('getTopStatistics') do
      getResult(Proc.new {
        @db.getTopStats
      }) 
    end
    
    @server.add_handler('getMyStatistics') do |sessionId|
      getResult(Proc.new {
        @db.getMyStats(sessionId)
      }) 
    end
  end

  def boardFunctions
    @server.add_handler('newGame') do |sessionId, gameSettings|
      game = GameModel.new gameSettings
      getResult(Proc.new {
        @db.newGame(sessionId, game)
      })
    end
     
    @server.add_handler('joinGame') do |sessionId, gameId|
      getResult(Proc.new {
        @db.joinGame(sessionId, gameId)
      })
    end
    
    @server.add_handler('registerReciever') do |sessionId, clientAddress|
      getResult(Proc.new {
        @registeredRefreshes[sessionId] = XMLRPC::Client.new(clientAddress)
      })
    end
    
    @server.add_handler('placeToken') do |sessionId, col|
       
    end
  end
  
  def buildResponse(status, data) 
    JSON.generate({:status => status, :data => data})
  end
  
  def getResult(proc)
    result = {}
    begin
      result[:data] = proc.call
      result[:status] = :ok
    rescue Exception => e
      result[:status] = :exception
      result[:data] = e
    end
    return result
  end
  
  # logs a client out, destroys their session
  def logout(client)
    client.puts buildResponse(:ok, "data")
  end  
  
  # returns all of the stats
  def getStats(client)
    client.puts buildResponse(:ok, "data") 
  end

  # returns the list of games the player is involved in
  def getGames(client)
    client.puts buildResponse(:ok, "data")
  end  

  # returns the address of the server that the game will be hosted on
  def newGame(client)
    a = client.addr
    myHost = a[3]
    gameId = client.gets.chomp
    client.puts buildResponse(:ok, "data")
  end
  
  # returns the address of the server that the game is hosted on
  def joinGame(client)
    client.puts "ok" # proceed
    gameId = client.gets.chomp
    
    # ensure we are only trying to check out a game one at a time
    @db.checkOut(:games, gameId) do |game|
      if !game # Invalid gameId
        return "invalid"
      end

      # check if game is currently checked out to a server
      serverAddress = game[:checkedOutTo]
      # send there
      return serverAddress if serverAddress

      #else check it out to us
      game[:checkedOutTo] = address
      @db.update(:games, game)
      return address
    end
    client.puts buildResponse(:ok, "data")
    
  end
  
  # returns the list of games the player is involved in
  def placeToken(client)
    client.puts buildResponse(:ok, "data")
  end  
  
  # sends a request for save
  def saveRequest(client)
    client.puts buildResponse(:ok, "data")
  end
  
  # responds to a save request
  def saveRespond(client)
    client.puts buildResponse(:ok, "data")
  end

  # allows a client to forfeit
  def forfeit(client)
    client.puts buildResponse(:ok, "data")
  end
  
  # returns the game model
  def getGame(client)
    client.puts buildResponse(:ok, "data")
  end

  def local_ip
    orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true  # turn off reverse DNS resolution temporarily

    UDPSocket.open do |s|
      s.connect '64.233.187.99', 1
      s.addr.last
    end
    ensure
      Socket.do_not_reverse_lookup = orig
  end

end