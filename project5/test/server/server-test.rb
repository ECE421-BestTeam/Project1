require 'test/unit'
require 'socket'
require_relative '../../lib/client/model/client-settings'
require_relative '../../lib/client/controller/board-online'
require_relative '../../lib/server/server'
require_relative '../../lib/common/model/game-settings'

class ServerTest < Test::Unit::TestCase
  
  def setup
    @port = 4222
    # start server
    @th = Thread.new {
      @server = Server.new(@port)
    }
   
  end

  def teardown
    @th.kill # kills the server thread
    @th.join
  end
  
  def test_typicalUsage
    #start the client1 controller
    sett = ClientSettingsModel.new
    sett.host = 'localhost'
    sett.port = @port
    gSett = GameSettingsModel.new(2, 'victoryNormal', 'compete')
    @client1 = BoardOnlineController.new({
      :clientSettings => sett,
      :gameSettings => gSett
    })
  
    #start the client2 controller
    sett = ClientSettingsModel.new
    sett.host = 'localhost'
    sett.port = @port
    gSett = GameSettingsModel.new(2, 'victoryNormal', 'compete')
    @client2 = BoardOnlineController.new({
      :clientSettings => sett,
      :gameSettings => gSett
    })
    
    assert_equal(
      true, 
      @client1.registerRefresh( Proc.new { |data|
          puts data
      })
    )
    
    
    @client1.close
    @client2.close
  end
 
  
end