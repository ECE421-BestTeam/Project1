require 'socket'
require 'xmlrpc/client'
require 'xmlrpc/server'
require_relative './database/database'
require_relative '../common/model/game'

# a server for all things connect4.2
class Server
  
  attr_reader :address, :db
  
  # time out is how long before a client is deemed inactive
  def initialize(port = 50500, timeout = 60 * 60)
    @port = port
    @timeout = timeout # default is an hour
    
    @db = Database.new
    
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
      rescue Errno::EADDRINUSE
        @port += 1
        if @port > 50550
          raise IOError, "Can not start Server."
        end
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
      getResult(Proc.new {
        game = GameModel.new gameSettings
        @db.newGame(sessionId, game)
      })
    end
     
    @server.add_handler('joinGame') do |sessionId, gameId|
      getResult(Proc.new {
        game = @db.joinGame(sessionId, gameId)
        if game['server_address'] == @address
          game
        else
          {
            'status' => 'redirect',
            'data' => game['server_address']
          }
        end
      })
    end
    
    @server.add_handler('registerReciever') do |sessionId, gameId, clientAddress|
      getResult(Proc.new {
        @games[gameId][sessionId] = clientAddress
        true
      })
    end
    
    @server.add_handler('placeToken') do |sessionId, col|
       
    end
  end
  
  def sendRefresh(gameId, sessionId, game)
    begin
      XMLRPC::Client.new(@games[gameId][sessionId]).call('refresh', game)
    rescue Exception => e
      puts 'Error refresshing game #{gameId}, session #{sessionId}, client #{@games[gameId][sessionId]}'
      puts e
    end
  end
  
  def buildResponse(status, data) 
    JSON.generate({:status => status, :data => data})
  end
  
  def getResult(proc)
    result = {}
    begin
      data = proc.call
      result['data'] = data
      result['status'] = 'ok'
      if data.class == Hash 
        if data.has_key?('status') && data.has_key?('data')
          result = data
        end
      end
    rescue Exception => e
      result['status'] = 'exception'
      result['data'] = {
        'class' => String(e.class),
        'message' => e.message,
        'backtrace' => e.backtrace
      }
    end
    return result
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