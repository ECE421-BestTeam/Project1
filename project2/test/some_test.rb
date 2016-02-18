# Tests that the factory produces the correct type of matrix

require 'test/unit'
require_relative '../lib/delay'

class DelayTest < Test::Unit::TestCase
  
  def setup
    # do nothing
  end

  def teardown
    # do nothing
  end
  
  def test_delay
    delay(10) {puts 'hi'}
  end
  
end