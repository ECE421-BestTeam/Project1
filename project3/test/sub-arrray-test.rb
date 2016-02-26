# Tests that the factory produces the correct type of matrix

require 'test/unit'
require '../lib/sub-array'

class SubArrayTest < Test::Unit::TestCase
  
  def setup
    @a = [1,2,3,4,5]
  end

  def teardown
    # do nothing
  end

  def test_deepcopy
    val = 101.2
    b = SubArray.new(@a, 1, 3, true)
    b[0] = val
    assert_equal val, b[0]
    assert_equal 2, @a[1]
  end
  
  def test_fromThread
    val = 101.2
    t = Thread.new { 
      b = SubArray.new(@a, 1, 3)
      b[0] = val
    }
    t.join
    assert_equal val, @a[1]
  end
  
  def test_subArrOfSubArr
    val = 101.2
    b = SubArray.new(@a, 1, 3)
    c = SubArray.new(b, 1, 2)
    b[1] = val
    assert_equal val, @a[2]
    assert_equal val, b[1]
    assert_equal val, c[0]
  end
  

end