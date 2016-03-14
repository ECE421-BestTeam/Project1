require 'test/unit'
require_relative '../../lib/model/victory'

class VictoryModelTest < Test::Unit::TestCase
  
  def setup
    
  end

  def teardown
    # do nothing
  end
  
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

  
end