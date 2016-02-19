# Tests that the factory produces the correct type of matrix

require 'test/unit'
require_relative '../lib/delay/delay'

class DelayTest < Test::Unit::TestCase
  
  def setup
    # do nothing
  end

  def teardown
    # do nothing
  end
  
  def test_delayedAction
    start = Time.now
    seconds = 1
    daVar = 1
    delayedAction(seconds) {daVar += 1}
    
    # The block should have been called
    assert_equal(2, daVar)
    
    timeTaken = Time.now - start
    # We should have taken at least seconds
    assert_operator seconds, :<=, Time.now - start
  end
  
  def test_delayedMessage
    start = Time.now
    seconds = 1

    delayedMessage(seconds, 0, '')
    
    timeTaken = Time.now - start
    # We should have taken at least seconds
    assert_operator seconds, :<=, Time.now - start
  end
  
  def test_argsCheck
    assert_raise(ArgumentError) { argsCheck('hi') }
    assert_raise(ArgumentError) { argsCheck(-1) }
    assert_raise(ArgumentError) { argsCheck(0, 'hi') }
    assert_raise(ArgumentError) { argsCheck(0, -1) }
    assert_raise(ArgumentError) { argsCheck(0, 999999999 + 1) }
  end
  
end
