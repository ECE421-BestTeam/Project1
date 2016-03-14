require 'test/unit'
require_relative '../../lib/controller/board'

class BoardControllerTest < Test::Unit::TestCase
  
  def setup
    
  end

  def teardown
    # do nothing
  end
  
  def implementationTests(type)
    assert_nothing_raised do
      cont = BoardController.new type
      cont.startGame(1, 0)
      cont.game
      cont.localPlayers
      cont.placeToken(0)
      cont.getNextActiveState
      cont.close
    end
  end
  
  def test_initialize
    
    assert_raise(MiniTest::Assertion) do
      BoardController.new -1
    end
    
  end
  
  def test_all
    implementationTests(0) #tests board-local
  end

  
end