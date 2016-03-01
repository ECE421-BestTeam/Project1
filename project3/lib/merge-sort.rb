require_relative './merge-sort-contract'
require 'timeout'

module MergeSort
  include MergeSortContract
  
  def sortInPlace(arr, duration = 0, &comparator)
    pre_sortInPlace(arr,duration,&comparator)
    shouldStop = [false]
    comparator ||= ->(a,b) { a <=> b }

    copyArr = []
    #make a deep copy
    (arr.length).times do |i|
        copyArr.push(arr[i])
    end
    th = Thread.new do
      mergeSort(copyArr, 0, copyArr.length-1, shouldStop, &comparator)
    end
      
    begin
      Timeout::timeout(duration) {
        th.join
      }
      #reference the sorted copy
      arr.length.times do |i|
        arr[i] = copyArr[i]
      end
      post_sortInPlace(arr,duration)
      
    rescue Timeout::Error
#      th.kill
      puts 'Time out!'
      shouldStop[0] = [true]
      th.join
      raise Timeout::Error
    end
    return arr
    
    
  end

  def mergeSort (arr, lefti, righti, shouldStop, &comparator)
    pre_mergesort(arr, lefti, righti, &comparator)

    #make sure you call merge with the subArrs being deepCopies.  
    #There is an option for that on init SubArray.new(arr, start, end, true)
    if shouldStop[0]
      return
    end
    
    if lefti < righti
      midpoint = (lefti+righti)/2

      t1 = Thread.new {

        mergeSort(arr, lefti, midpoint, shouldStop, &comparator) #sort left
      }
      mergeSort(arr, midpoint+1, righti, shouldStop, &comparator) #sort right

      
      t1.join
      t1.kill
      
      merge(
        SubArray.new(arr,lefti,righti,false),
        SubArray.new(arr,lefti, midpoint,true),
        SubArray.new(arr, midpoint+1, righti,true),
        shouldStop,
        &comparator
      )

    end
    post_mergesort(arr, lefti, righti)
  end
  
  # Merges subArrA and 2 onto arr (C)
  # arr should carry through (pass by ref)
  # the subArr should be a deep copy though... 
  # Maybe only required to deep copy when coming in from mergeSort
  def merge (arr, subArrA, subArrB, shouldStop, &comparator)
    pre_merge(arr, subArrA, subArrB, &comparator)

    if shouldStop[0]
      return
    end
    
    aLen = subArrA.length
    bLen = subArrB.length
    totalLen = aLen + bLen
    if bLen > aLen # larger array should be first
      merge(arr, subArrB, subArrA, shouldStop, &comparator)
    elsif totalLen == 1 # we have an unpaired array (eg. B is 0 long)
      arr[0] = subArrA[0]
    elsif aLen == 1  # and therefore bLen = 1
      # order the results in the array
      if comparator.call(subArrA[0], subArrB[0]) < 0
        arr[0] = subArrA[0]
        arr[1] = subArrB[0]
      else
        arr[0] = subArrB[0]
        arr[1] = subArrA[0]
      end
    else 
      # at least the left arr is > 1 long, so...
      halfA = (aLen -1) / 2
      j = binarySearch(subArrB, subArrA[halfA], &comparator)  # such that B[j] < A[halfA] <= B[j +1]
      t1 = Thread.new {
        # Handles elem A[0] and all elems in b < A[0]
        merge(
          SubArray.new(arr, 0, halfA + j + 1), #result part
          SubArray.new(subArrA, 0, halfA), #part A
          SubArray.new(subArrB, 0, j), #part B
          shouldStop,
          &comparator
        ) 
      }
      # Handles all remaining in A and B (all >= A[0])
      merge(
        SubArray.new(arr, halfA + j + 1 + 1, totalLen - 1), #result part
        SubArray.new(subArrA, halfA + 1, aLen - 1), #part A
        SubArray.new(subArrB, j + 1, bLen - 1), #part B
        shouldStop,
        &comparator
      ) 
      t1.join
      t1.kill
    end
    
    post_merge(arr, subArrA, subArrB)
  end

  # returns j such that arr[j] < elem <= arr[j +1]
  # returns the index of the largest element that is < elem
  # arr is a SubArray or Array ordered from lowest to highest
  def binarySearch (arr, elem, &comparator)

    pre_binarySearch(arr, elem)
    return _binsearch(arr, elem, 0, arr.length-1, &comparator)-1

  end

  def _binsearch(arr, elem, left, right, &comparator)
    return 0 if arr.length == 0
    mid = (left+right)/2
    if right == left
      return right+1 if comparator.call(arr[right],elem) < 0
      return left
    end
    return mid if comparator.call(arr[mid],elem) == 0
    return _binsearch(arr, elem, left, mid, &comparator) if comparator.call(elem,arr[mid]) < 0
    return _binsearch(arr, elem, mid+1, right, &comparator) if comparator.call(arr[mid], elem) < 0
  end

end