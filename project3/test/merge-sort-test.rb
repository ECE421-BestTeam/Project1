# Tests that the factory produces the correct type of matrix

require 'test/unit'
require_relative '../lib/merge-sort'

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
  
#  def test_sortInPlace
#    a = [3,7,9,5,11,8]
#    sortInPlace(a, 0)
#  end

  def test_mergeSort
    a = [7, 3,9,5,11,8]
    sortedA = [3,5,7,8,9,11]
    mergeSort(a, 0 , a.length-1)
    checkArray(sortedA,a)
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