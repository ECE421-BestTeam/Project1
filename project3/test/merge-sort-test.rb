# Tests that the factory produces the correct type of matrix

require 'test/unit'
require '../lib/merge-sort'

class MergeSortTest < Test::Unit::TestCase
  include MergeSort
  
  def checkArray(expectedArr, arr)
    # check number of rows
    assert_equal(expectedArr.length, arr.length)
    
    # Test that each element is correct
    expectedArr.each_with_index { |val, i| 
      assert_equal(val, arr[i])
    }
  end
  
  def setup
  end

  def teardown
    # do nothing
  end

  def test_merge
    a = [3,7,9,5,8,11]
    sortedA = [3,5,7,8,9,11]
    merge(
      a, 
      SubArray.new(a, 0, 2, true), 
      SubArray.new(a, 3, 5, true)
    )
    checkArray(sortedA, a)
    
    b = [3,7,9,5,8]
    sortedB = [3,5,7,8,9]
    merge(
      b, 
      SubArray.new(b, 0, 2, true), 
      SubArray.new(b, 3, 4, true)
    )
    checkArray(sortedB, b)
    
  end
  
end