# Tests that the factory produces the correct type of matrix

require 'test/unit'
require_relative '../lib/merge-sort'
require 'benchmark'

class MergeSortTest < Test::Unit::TestCase
  include MergeSort
  
  def checkArray(expectedArr, arr)
    # check number of rows
    assert_equal(expectedArr.length, arr.length)
    
    # Test that each element is correct
    expectedArr.each_with_index do |val, i| 
      assert_equal val, arr[i], "expected: #{expectedArr}, \ngot:\t  #{arr}"
    end
  end
  
  def setup
    @duration = 3
  end

  def teardown
    # do nothing
  end
  
  def test_sortInPlace
    a = Array.new(1000) { rand(100) }
    sortedA = a.sort
    puts "\nstart sort 1000"
    assert_nothing_raised do
      sortInPlace(a, @duration)
    end

    
    a = Array.new(5000) { rand(100) }
    sortedA = a.sort
    puts "\nstart sort 5000"
    assert_raise Timeout::Error do
      sortInPlace(a, @duration)
    end
    
    a = Array.new(10000) { rand(100) }
    sortedA = a.sort
    puts "\nstart sort 10000"
    assert_raise Timeout::Error do
      sortInPlace(a, @duration)
    end
    
  end

  def test_mergeSort
    a = [7,3,9,5,11,8]
    sortedA = [3,5,7,8,9,11]
    mergeSort(a, 0 , a.length-1)
    checkArray(sortedA,a)
    
    a = [3,2,1]
    sortedA = [1,2,3]
    mergeSort(a, 0 , a.length-1)
    checkArray(sortedA,a)
    
    a = [3,2,3]
    sortedA = [2,3,3]
    mergeSort(a, 0 , a.length-1)
    checkArray(sortedA,a)
    
    a = [3,3,1]
    sortedA = [1,3,3]
    mergeSort(a, 0 , a.length-1)
    checkArray(sortedA,a)
    
    a = [3,2,1,4,3]
    sortedA = [1,2,3,3,4]
    mergeSort(a, 0 , a.length-1)
    checkArray(sortedA,a)
    
    a = [-1,-2,-3,-4,-5]
    sortedA = [-5,-4,-3,-2,-1]
    mergeSort(a, 0 , a.length-1)
    checkArray(sortedA,a)
    
    a = [20,20,20,20,20,20,20]
    sortedA = a.sort
    
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

  
  def search(arr, elem)
    i = 0
    while i < arr.length && arr[i] < elem
      i += 1
    end
    return i - 1
  end

  def test_binarySearch
    sortedA = [3,5,7,8,9,11]
    
    assert_equal search(sortedA,3),binarySearch(sortedA,3)
    assert_equal search(sortedA,7),binarySearch(sortedA,7)
    assert_equal search(sortedA,2),binarySearch(sortedA,2)
    assert_equal search(sortedA,6),binarySearch(sortedA,6)
    
    sortedA = SubArray.new(sortedA,2, 4)
    assert_equal search(sortedA,10),binarySearch(sortedA,10)
    assert_equal search(sortedA,11),binarySearch(sortedA,11)
    assert_equal search(sortedA,12),binarySearch(sortedA,12)
    

    
  end
     
  
end