require 'test/unit'
require_relative '../../lib/model/game'

class GameTest < Test::Unit::TestCase
  
  def setup
  end

  def teardown
    # do nothing
  end
  
  def test_wait_finishes_2P
    #should finish
    g = ConnectFourGame.new(2, 0)
    # 1st player turn
    p1 = Thread.new {
      g.placeToken(0)
      g.waitForNextUpdate(1)
    }
    g.placeToken(1) # 2nd player turn
    assert_equal p1, p1.join(1)
  end
  
  def test_wait_doesnt_finish_2P
    #should not finish because 2nd player did not take turn
    g = ConnectFourGame.new(2, 0)
    # 1st player turn
    p1 = Thread.new {
      g.placeToken(0) 
      g.waitForNextUpdate(1)
    }
    assert_equal nil, p1.join(1)
  end

  
end