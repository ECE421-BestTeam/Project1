# Tests that the factory produces the correct type of matrix

require 'test/unit'
require '../lib/sub-array'

class SubArrayTest < Test::Unit::TestCase
  
  def setup
    # do nothing
  end

  def teardown
    # do nothing
  end

  def test_something
    a = [1,2,3,4,5]
    t = Thread.new { 
      b = SubArray.new(a, 1, 3)
      b[0] = 10
      puts b
      p "a from in child"
      p a
    }
    t.join
    p "a from in parent"
    p a
  end
  
    def test_something2
    a = [1,2,3,4,5]
    b = SubArray.new(a, 1, 3)
    c = SubArray.new(b, 1, 2)
    b[0] = 20
    p a
    puts b
    puts c
  end
  
end