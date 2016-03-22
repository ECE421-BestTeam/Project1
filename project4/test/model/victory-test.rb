require 'test/unit'
require_relative '../../lib/model/victory'

class VictoryModelTest < Test::Unit::TestCase
  
  def setup
    
  end

  def teardown
    # do nothing
  end
  
  # just checks that no errors are thrown
  # the contracts that are run ensure that 
  # the correct types are going in and out
  def implementationTests(type)
    assert_nothing_raised do
      cont = VictoryModel.new type
      cont.name
      cont.playerToken(0)
      cont.playerToken(1)
      cont.checkVictory([[0]])
    end
  end
  
  def test_initialize
    
    assert_raise(MiniTest::Assertion) do
      VictoryModel.new -1
    end
    
  end
  
  def test_all
    implementationTests(:victoryNormal) #tests victory-normal
    implementationTests(:victoryOtto) #tests victory-otto
  end

  def test_checkVictory_normal
    v = VictoryModel.new :victoryNormal
    board = [ [nil,nil,nil,nil,nil,nil],
              [nil,nil,nil,nil,nil,nil],
              [nil,nil,nil,nil,nil,nil],
              [nil,nil,nil,nil,nil,nil],
              [nil,nil,nil,nil,nil,nil]]
    assert_equal nil, v.checkVictory(board)
    
    board = [ [nil,nil,nil,nil,nil,nil],
              [ 0 , 0 , 0 , 0 ,nil,nil],
              [nil,nil,nil,nil,nil,nil],
              [nil,nil,nil,nil,nil,nil],
              [nil,nil,nil,nil,nil,nil]]
    assert_equal :player1, v.checkVictory(board)
    
    board = [ [nil,nil, 1 ,nil,nil,nil],
              [ 0 , 0 , 1 , 0 ,nil,nil],
              [nil,nil, 1 ,nil,nil,nil],
              [nil,nil, 1 ,nil,nil,nil],
              [nil,nil,nil,nil,nil,nil]]
    assert_equal :player2, v.checkVictory(board)
    
    board = [ [nil,nil, nil ,nil,nil,nil],
              [ 0 , 0 , 1 , 0 ,nil,nil],
              [nil,nil, 1 ,nil, 0 ,nil],
              [nil,nil, 1 ,nil,nil, 0 ],
              [ 0 , 0 , 0 , 0 ,nil,nil]]
    assert_equal :player1, v.checkVictory(board)
    
    board = [ [nil,nil,nil,nil,nil,nil,nil],
              [ 1 ,nil, 1 ,nil,nil,nil,nil],
              [ 1 , 1 , 0 ,nil, 0 ,nil,nil],
              [ 0 , 0 , 1 ,nil, 1 , 1 , 1 ],
              [ 1 , 0 , 0 ,0 , 0 , 1 , 1 ]]
    assert_equal :player1, v.checkVictory(board)
    
    board = [ [ 1 ,nil,nil, 0 , 1 , 1 , 1 ],
              [ 1 , 1 , 1 , 0 ,nil,nil,nil],
              [ 1 , 1 , 1 , 0 , 0 ,nil,nil],
              [ 0 , 0 , 0 , 1 , 0 , 1 , 1 ],
              [ 1 , 0 , 0 , 1 , 0 , 0 , 1 ]]
    assert_equal :player2, v.checkVictory(board)
    
    board = [ [ 1 , 0 , 1 , 0 , 1 , 0 ],
              [ 1 , 0 , 1 , 0 , 1 , 0 ],
              [ 0 , 1 , 0 , 1 , 0 , 1 ],
              [ 0 , 1 , 0 , 1 , 0 , 1 ],
              [ 1 , 0 , 1 , 0 , 1 , 0 ]]
    assert_equal :draw, v.checkVictory(board)
  end
  
  def test_checkVictory_otto
    v = VictoryModel.new :victoryOtto
    board = [ [nil,nil,nil,nil,nil,nil],
              [nil,nil,nil,nil,nil,nil],
              [nil,nil,nil,nil,nil,nil],
              [nil,nil,nil,nil,nil,nil],
              [nil,nil,nil,nil,nil,nil]]
    assert_equal nil, v.checkVictory(board)
    
    board = [ [nil,nil,nil,nil,nil,nil],
              [ 0 , 1 , 1 , 0 ,nil,nil],
              [nil,nil,nil,nil,nil,nil],
              [nil,nil,nil,nil,nil,nil],
              [nil,nil,nil,nil,nil,nil]]
    assert_equal :player1, v.checkVictory(board)
    
    board = [ [nil,nil, 1 ,nil,nil,nil],
              [ 1 , 0 , 0 , 0 ,nil,nil],
              [nil,nil, 0 ,nil,nil,nil],
              [nil,nil, 1 ,nil,nil,nil],
              [nil,nil,nil,nil,nil,nil]]
    assert_equal :player2, v.checkVictory(board)
    
    board = [ [nil,nil, 1 ,nil,nil,nil],
              [ 0 , 1 , 0 , 0 ,nil,nil],
              [nil,nil, 1 ,nil, 0 ,nil],
              [nil,nil, 1 ,nil,nil, 1 ],
              [nil,nil,nil,nil,nil,nil]]
    assert_equal :player2, v.checkVictory(board)
    
    board = [ [ 1 , 1 , 1 , 1 , 1 , 1 ],
              [ 1 , 1 , 1 , 1 , 1 , 1 ],
              [ 1 , 1 , 1 , 1 , 1 , 1 ],
              [ 1 , 1 , 1 , 1 , 1 , 1 ],
              [ 1 , 1 , 1 , 1 , 1 , 1 ]]
    assert_equal :draw, v.checkVictory(board)
  end
  
end