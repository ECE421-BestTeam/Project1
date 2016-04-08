require 'test/unit'
require_relative '../../../lib//common/model/victory'

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
      cont.checkVictory([[1]])
    end
  end
  
  def test_initialize
    
    assert_raise(MiniTest::Assertion) do
      VictoryModel.new -2
    end
    
  end
  
  def test_all
    implementationTests('victoryNormal') #tests victory-normal
    implementationTests('victoryOtto') #tests victory-otto
  end

  def test_checkVictory_normal
    v = VictoryModel.new 'victoryNormal'
    board = [ [0,0,0,0,0,0],
              [0,0,0,0,0,0],
              [0,0,0,0,0,0],
              [0,0,0,0,0,0],
              [0,0,0,0,0,0]]
    assert_equal 0, v.checkVictory(board)
    
    board = [ [0,0,0,0,0,0],
              [1,1,1,1,0,0],
              [0,0,0,0,0,0],
              [0,0,0,0,0,0],
              [0,0,0,0,0,0]]
    assert_equal2, v.checkVictory(board)
    
    board = [ [0,0,2,0,0,0],
              [1,1,2,1,0,0],
              [0,0,2,0,0,0],
              [0,0,2,0,0,0],
              [0,0,0,0,0,0]]
    assert_equal2, v.checkVictory(board)
    
    board = [ [0,0, 0 ,0,0,0],
              [1,1,2,1,0,0],
              [0,0,2,0,1,0],
              [0,0,2,0,0, 1 ],
              [1,1,1,1,0,0]]
    assert_equal2, v.checkVictory(board)
    
    board = [ [0,0,0,0,0,0,0],
              [2,0,2,0,0,0,0],
              [2,2,1,0,1,0,0],
              [1,1,2,0,2,2, 2 ],
              [2,1,1,1,1,2, 2 ]]
    assert_equal2, v.checkVictory(board)
    
    board = [ [2,0,0,1,2,2, 2 ],
              [2,2,2,1,0,0,0],
              [2,2,2,1,1,0,0],
              [1,1,1,2,1,2, 2 ],
              [2,1,1,2,1,1, 2 ]]
    assert_equal2, v.checkVictory(board)
    
    board = [ [0,0,2,0,1,0],
              [1,1,2,0,0,0],
              [0,0,1,0,0,0],
              [0,1,2,0,0,0],
              [1,0,0,0,0,0]]
    assert_equal 0, v.checkVictory(board)
    
    board = [ [2,1,2,1,2, 1 ],
              [2,1,2,1,2, 1 ],
              [1,2,1,2,1, 2 ],
              [1,2,1,2,1, 2 ],
              [2,1,2,1,2, 1 ]]
    assert_equal 3, v.checkVictory(board)
  end
  
  def test_checkVictory_otto
    v = VictoryModel.new 'victoryOtto'
    board = [ [0,0,0,0,0,0],
              [0,0,0,0,0,0],
              [0,0,0,0,0,0],
              [0,0,0,0,0,0],
              [0,0,0,0,0,0]]
    assert_equal 0, v.checkVictory(board)
    
    board = [ [0,0,0,0,0,0],
              [1,2,2,1,0,0],
              [0,0,0,0,0,0],
              [0,0,0,0,0,0],
              [0,0,0,0,0,0]]
    assert_equal2, v.checkVictory(board)
    
    board = [ [0,0,2,0,0,0],
              [2,1,1,1,0,0],
              [0,0,1,0,0,0],
              [0,0,2,0,0,0],
              [0,0,0,0,0,0]]
    assert_equal2, v.checkVictory(board)
    
    board = [ [0,0,2,0,0,0],
              [1,2,1,1,0,0],
              [0,0,2,0,1,0],
              [0,0,2,0,0, 2 ],
              [0,0,0,0,0,0]]
    assert_equal2, v.checkVictory(board)
    
    board = [ [2,2,2,2,2, 2 ],
              [2,2,2,2,2, 2 ],
              [2,2,2,2,2, 2 ],
              [2,2,2,2,2, 2 ],
              [2,2,2,2,2, 2 ]]
    assert_equal 3, v.checkVictory(board)
  end
  
end