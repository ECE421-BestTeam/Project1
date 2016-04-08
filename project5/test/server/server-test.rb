require 'test/unit'
require 'socket'
require_relative '../../lib/client/model/client-settings'
require_relative '../../lib/common/model/game-settings'
require_relative '../../lib/common/model/game'
require_relative '../../lib/client/controller/menu'
require_relative '../../lib/server/server'
require_relative '../../lib/server/database/database'

class ServerTest < Test::Unit::TestCase
  
  $acc1 = {:username => 'test1', :password => 'test1pass'}
  $acc2 = {:username => 'test2', :password => 'test2pass'}
  
  def setup
    port = 50500
    
    @server1 = Server.new(port)
    @port1 = @server1.port
    @server1.start
    
    @server2 = Server.new(@port1 + 1)
    @port2 = @server2.port
    @server2.start
    
    @removes = []
    @removes.push(['Player', $acc2[:username]])
    @removes.push(['Player', $acc1[:username]])
    doRemoval
    @removes.push(['Server', @server1.address])
    @removes.push(['Server', @server2.address])
    
    sleep 1 # make sure servers are running
    startClients
  end

  def teardown
    doRemoval
    @server1.close
    @server2.close
    @client1.close
    @client2.close
  end
  
  def doRemoval
    db = Database.new
    @removes.each do |pair|
      db.remove(pair[0], pair[1])
    end
  end
  
  def startClients
    #start the client1 controller
    sett = ClientSettingsModel.new
    sett.host = 'localhost'
    sett.port = @port1
    @client1 = MenuController.new(sett)
    @client1.connect
    puts '------------------------------------------------------STARTED CLIENT1'
      
    # start the client2 controller
    sett = ClientSettingsModel.new
    sett.host = 'localhost'
    sett.port = @port2
    @client2 = MenuController.new(sett)
    @client2.connect
    puts '------------------------------------------------------STARTED CLIENT2'
    
    @client1.createPlayer($acc2[:username], $acc2[:password])
    @client1.createPlayer($acc1[:username], $acc1[:password])
    puts '------------------------------------------------------CLIENT1 CREATED ACCOUNTS'

    @client2.login($acc2[:username], $acc2[:password])
    puts '------------------------------------------------------CLIENT2 LOGGED IN'
  end
  
  def test_playGame
   
    gSett = GameSettingsModel.new(2, 'victoryNormal')
    @board1 = @client1.getBoardController('online', gSett)
    
    i = 0
    while (gameId = @board1.implementation.gameId).length == 0
      sleep 0
      i += 1
      raise Exception, "could not get gameId" if i > 25
    end
      
    @removes.push(['Game', gameId])
    puts '------------------------------------------------------GOT CLIENT1 BOARD CONTROLLER'
    
    games = @client2.getGames    
    puts '------------------------------------------------------GOT GAMES'
    
    @board2 = @client2.getBoardController('online', gameId)
        i = 0
    while (gameId = @board2.implementation.gameId).length == 0
      sleep 0
      i += 1
      raise Exception, "could not get gameId" if i > 25
    end
    puts '------------------------------------------------------GOT CLIENT2 BOARD CONTROLLER'
    
    @turn = [0, -1, -1]
    @refresh1 = Proc.new { |data|
      assert data.class == GameModel
      @turn[1] += 1
      puts "Refresh1:#{@turn[1]}"
      assert data.turn == @turn[1], "failed on turn #{@turn[1]}"
    }
    @refresh2 = Proc.new { |data|
      assert data.class == GameModel
      @game2 = data
      @turn[2] += 1
      puts "Refresh2:#{@turn[2]}"
      assert data.turn == @turn[2], "failed on turn #{@turn[2]}"
    }
    
    @board1.registerRefresh(@refresh1)
    @board2.registerRefresh(@refresh2)
    puts '------------------------------------------------------REGISTERED REFRESHES'
    
    #1
    @board1.placeToken(1)
    
    assert_raise(ArgumentError) do
      @board1.placeToken(1)  
    end
    
    #2
    @board2.placeToken(0)
    #3
    @board1.placeToken(2)
    #4
    @board2.placeToken(0)
    #5
    @board1.placeToken(3)
    #6
    @board2.placeToken(0)
    #7
    @board1.placeToken(4)
    
    assert_raise(GameOverError) do
      @board2.placeToken(2)  
    end
  end
  
end