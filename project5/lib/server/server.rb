require 'socket'
require 'xmlrpc/client'
require 'xmlrpc/server'
require_relative './database/database'
require_relative '../common/model/game'

# a server for all things connect4.2
class Server
  
  attr_reader :address, :db, :port, :host
  
  # time out is how long before a client is deemed inactive
  def initialize(port = 50500, timeout = 60 * 60)
    @port = port
    @timeout = timeout # default is an hour
    
    @db = Database.new
    
    # Hash of all current games.
#    {
#      'gameID1' => {
#        'game' => gameObject,
#        'player1' => { 'session' => 'sessId1', 'address' => client1Address},
#        'player2' => { 'session' => 'sessId2', 'address' => client2Address}
#        }
#      }
#    }
    @games = {}
    
  end
  
  # Starts the server and registers all it's handlers
  def start
    endPort = @port + 50
    while true
      begin
        @server = XMLRPC::Server.new(@port)
        break
      rescue Errno::EADDRINUSE
        @port += 1
        if @port > endPort 
          raise IOError, "Can not start Server."
        end
      end
    end
    
    @host = local_ip
    @address = "#{@host}:#{@port}"
    puts "listening on #{address}"
    games = @db.registerServer(address)
    
    # Recovery if server went down
    games.each do |game|
      
    end
    
    menuFunctions
    
    boardFunctions    

    @thread = Thread.new {
      @server.serve
    }
  end
  
  def close
    @server.shutdown
    @thread.join
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
     
    getPlayerNumber = Proc.new do |gameEntry, username|
      if gameEntry['player1_id'] == username
        1
      elsif dagameEntryta['player2_id'] == username
        2
      else
        raise ArgumentError, "Player is not part of current game."
      end
    end
    
    @server.add_handler('joinGame') do |sessionId, gameId|
      getResult(Proc.new {
        gameEntry = @db.joinGame(sessionId, gameId)
        if gameEntry['server_address'] == @address
          # we are hosting
          username = @db.getPlayerID(sessionId)
          playerNumber = getPlayerNumber.call gameEntry, username
          if !@games[gameId]
            @games[gameId] = {
              'game' => gameEntry['game_model'],
              'player1' => {},
              'player2' => {}
            }
          end
          @games[gameId]["player#{playerNumber}"]['session'] = sessionId
          playerNumber - 1 # board-online is 0-indexed
        else
          # another server is hosting
          {
            'status' => 'redirect',
            'data' => gameEntry['server_address']
          }
        end
      })
    end
    
    @server.add_handler('registerReciever') do |sessionId, gameId, clientAddress|
      getResult(Proc.new {
        #test the connection
        getConnection(clientAddress)
        @games[gameId][sessionId] = clientAddress
      })
    end
    
    @server.add_handler('placeToken') do |sessionId, gameId, col|
      getResult(Proc.new {
        game = @games[gameId]['game']
        #if it is the requester's turn
        if sessionId == @games[gameId]["player#{(game.turn % 2) +1}"]['session']
          game.placeToken(col)
          if game.winner != 0
            # do finishing stuff
            gameEnd(gameId, game.winner)
          else
            @db.updateGame(gameId, 'game_model', game)
            sendRefresh(gameId)
          end
        end
        true
      })
    end
  end
  
  def gameEnd(gameId, winner)
    if winner == 3
      sessionId = @games[gameId]['player1']['session']
      @db.updateStat(sessionId, 'draws', 1) if sessionId
      
      sessionId = @games[gameId]['player2']['session']
      @db.updateStat(sessionId, 'draws', 1) if sessionId
    else
      sessionId = @games[gameId]["player#{winner}"]['session']
      @db.updateStat(sessionId, 'wins', 1) if sessionId

      sessionId = @games[gameId]["player#{(winner%2) + 1}"]['session']
      @db.updateStat(sessionId, 'losses', 1) if sessionId
    end
    @db.remove('Game', gameId)
    @games.delete(gameId)
  end
  
  def sendRefresh(gameId)
    game = @games[gameId]['game']
    (1..2).each do |i|
      address = @games[gameId]["player#{i}"]['address']
      callRefresh(address, game) if address
    end
  end
  
  def callRefresh(address, game)
    begin
      getConnection(address).call('refresh', game)
    rescue Exception => e
      puts "Error sending refresh to #{address}"
    end
  end
  
  def getConnection(address)
        if address.class == String
      add = address.split(':')
      host = add[0]
      port = add[1]
    else
      host = address['host']
      port = address['port']
    end
    host = 'localhost' if host == @host
    begin
      con = XMLRPC::Client.new(host, nil, port)
      return con
    rescue Exception => e
      puts "Error sending connecting to #{address}"
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