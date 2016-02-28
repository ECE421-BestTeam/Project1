require_relative './merge-sort-contract'
require 'timeout'

module MergeSort
  include MergeSortContract

  def sortInPlace (arr, duration = 0)
    pre_sortInPlace(arr,duration)
   
     begin
      pid = Process.fork
      if pid.nil?
        mergeSort(arr, 0, arr.length-1)
        exit
      else
        Timeout::timeout(duration) {
          Process.wait(pid)
        }
      end
      post_sortInPlace(arr,duration)
    rescue Timeout::Error
      Process.kill('TERM', pid)
      puts 'process not finished in time, killing it'
      raise Timeout::Error
    rescue Interrupt
      abort("User interrupted sort")
    rescue SignalException
    rescue SystemExit
    ensure
    
    end
    
  end

  def mergeSort (arr, lefti, righti)
    pre_mergesort(arr, lefti, righti)
    #make sure you call merge with the subArrs being deepCopies.  
    #There is an option for that on init SubArray.new(arr, start, end, true)
    threads = []
    if lefti < righti
      midpoint = (lefti+righti)/2

      t1 = Thread.new {
        mergeSort(arr, lefti, midpoint) #sort left
      }
      mergeSort(arr, midpoint+1, righti) #sort right
      
      t1.join
      t1.kill
      
      merge(
        SubArray.new(arr,lefti,righti),
        SubArray.new(arr,lefti, midpoint,true),
        SubArray.new(arr, midpoint+1, righti,true)
      )

    end
    post_mergesort(arr, lefti, righti)
  end
  
  # Merges subArrA and 2 onto arr (C)
  # arr should carry through (pass by ref)
  # the subArr should be a deep copy though... 
  # Maybe only required to deep copy when coming in from mergeSort
  def merge (arr, subArrA, subArrB)
    pre_merge(arr, subArrA, subArrB)

    aLen = subArrA.length
    bLen = subArrB.length
    totalLen = aLen + bLen
    if bLen > aLen # larger array should be first
      merge(arr, subArrB, subArrA)
    elsif totalLen == 1 # we have an unpaired array (eg. B is 0 long)
      arr[0] = subArrA[0]
    elsif aLen == 1  # and therefore bLen = 1
      # order the results in the array
      temp = [subArrA[0], subArrB[0]]
      arr[0] = temp.min
      arr[1] = temp.max
    else 
      # at least the left arr is > 1 long, so...
      halfA = (aLen -1) / 2
      j = binarySearch(subArrB, subArrA[halfA])  # such that B[j] < A[halfA] <= B[j +1]
      t1 = Thread.new {
        # Handles elem A[0] and all elems in b < A[0]
        merge(
          SubArray.new(arr, 0, halfA + j + 1), #result part
          SubArray.new(subArrA, 0, halfA), #part A
          SubArray.new(subArrB, 0, j) #part B
        ) 
      }
      # Handles all remaining in A and B (all >= A[0])
      merge(
        SubArray.new(arr, halfA + j + 1 + 1, totalLen - 1), #result part
        SubArray.new(subArrA, halfA + 1, aLen - 1), #part A
        SubArray.new(subArrB, j + 1, bLen - 1) #part B
      ) 
      t1.join
      t1.kill
    end
    
    post_merge(arr, subArrA, subArrB)
  end

  # returns j such that arr[j] < elem <= arr[j +1]
  # returns the index of the largest element that is < elem
  # arr is a SubArray or Array ordered from lowest to highest
  def binarySearch (arr, elem)
    pre_binarySearch(arr, elem)
    return _binsearch(arr, elem, 0, arr.length-1)-1

  end

  def _binsearch(arr, elem, left, right)
    return 0 if arr.length == 0
    mid = (left+right)/2
    if right == left
      return right+1 if arr[right] < elem
      return left
    end
    return mid if arr[mid] == elem
    return _binsearch(arr, elem, left, mid) if elem < arr[mid]
    return _binsearch(arr, elem, mid+1, right) if arr[mid] < elem
  end

end