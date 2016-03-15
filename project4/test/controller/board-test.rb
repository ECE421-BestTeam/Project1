require 'test/unit'
require_relative '../../lib/controller/board'
require_relative '../../lib/model/settings'

class BoardControllerTest < Test::Unit::TestCase
  
  def setup
    
  end

  def teardown
    # do nothing
  end
  
  def implementationTests(type)
    assert_nothing_raised do
      cont = BoardController.new type, SettingsModel.new
      cont.settings
      cont.localPlayers
      cont.startGame
      cont.placeToken(0)
      cont.getNextActiveState
      cont.close
    end
  end
  
  def test_initialize
    
    assert_raise(MiniTest::Assertion) do
      BoardController.new -1, SettingsModel.new
    end
    
  end
  
  def test_all
    implementationTests(0) #tests board-local
  end

  
end

      cont = BoardController.new 0, SettingsModel.new
      cont.settings
      cont.localPlayers
      cont.startGame
      cont.placeToken(0)
      cont.getNextActiveState
      cont.close