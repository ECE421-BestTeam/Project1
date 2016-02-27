require_relative './merge-sort-contract'

module MergeSort
  include MergeSortContract

  def sortInPlace (arr, duration)
    # do something funky with timing
    mergeSort(arr, 0, arr.length-1)
    # break out if timing got funky

  end

  def mergeSort (arr, lefti, righti)
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
      
      merge(
        SubArray.new(arr,lefti,righti),
        SubArray.new(arr,lefti, midpoint,true),
        SubArray.new(arr, midpoint+1, righti,true)
      )

    end
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
      halfA = aLen / 2
      j = binarySearch(subArrB, subArrA[halfA])  # such that A[j] <=  B[l/2] <= A[j +1]
      t1 = Thread.new {
        merge(
          SubArray.new(arr, 0, halfA + j - 1), #result part
          SubArray.new(subArrA, 0, halfA - 1), #part A
          SubArray.new(subArrB, 0, j - 1) #part B
        ) 
      }
      merge(
        SubArray.new(arr, halfA + j, totalLen - 1), #result part
        SubArray.new(subArrA, halfA, aLen - 1), #part A
        SubArray.new(subArrB, j, bLen - 1) #part B
      ) 
      t1.join
    end
    
    post_merge(arr, subArrA, subArrB)
  end

  # returns j such that arr[j] <= elem <= arr[j +1]
  # arr is a SubArray or Array
  def binarySearch (arr, elem)
    pre_binarySearch(arr, elem)
    arr.each_index do |j| 
      if arr[j] >= elem
        return [j - 1, 0].max
      end
    end
    
    # else return the last index
    return [arr.length - 1, 0].max
  end
  
end