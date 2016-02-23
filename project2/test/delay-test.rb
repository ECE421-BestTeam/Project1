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
    seconds = 1.0
    daVar = 1.0
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

    delayedMessage(seconds, '')
    
    timeTaken = Time.now - start
    # We should have taken at least seconds
    assert_operator seconds, :<=, Time.now - start
  end
  
end
