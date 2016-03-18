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
    implementationTests(0) #tests victory-normal
    implementationTests(1) #tests victory-otto
  end

  def test_checkVictory_normal
    v = VictoryModel.new 0
    board = [ [nil,nil,nil,nil],
              [nil,nil,nil,nil],
              [nil,nil,nil,nil],
              [nil,nil,nil,nil]]
    assert_equal 3, v.checkVictory(board)
    
    board = [ [nil,nil,nil,nil],
              ['O','O','O','O'],
              [nil,nil,nil,nil],
              [nil,nil,nil,nil]]
    assert_equal 1, v.checkVictory(board)
    
    board = [ [nil,nil,'X',nil],
              ['O','O','X','O'],
              [nil,nil,'X',nil],
              [nil,nil,'X',nil]]
    assert_equal 2, v.checkVictory(board)
    
    board = [ [nil,nil,'X','O'],
              ['O','X','O','O'],
              [nil,'O','X',nil],
              ['O',nil,'X',nil]]
    assert_equal 1, v.checkVictory(board)
  end
  
end