require_relative './merge-sort-contract'

module MergeSort
  include MergeSortContract

  def sortInPlace (arr, duration)
    # do something funky with timing
    mergeSort(arr, 0, arr.length)
    # break out if timing got funky
  end

  def mergeSort (arr, p, r)
  end
  
  # Merges subArrA and 2 onto arr (C)
  def merge (arr, subArrA, subArrB)
    pre_merge(arr, subArrA, subArrB)

    l = aLen = subArrA.length
    m = bLen = subArrB.length
    n = totalLen = aLen + bLen
    if bLen > aLen # larger array should be first
      merge(arr, subArrB, subArrA)
    elsif totalLen == 1 # we have an unpaired array (eg. B is 0 long)
      # No need for action? as it is in correct place already...
      arr[0] = subArrA[0]
    elsif aLen == 1  # and therefore bLen = 1
      # order the results in the array
      tempA = subArrA[0]
      tempB = subArrB[0]
      if tempA <= tempB
        arr[0] = tempA
        arr[1] = tempB
      else 
        arr[0] = tempB
        arr[1] = tempA
      end
    else 
      # at least the left arr is > 1 long, so...
      j = binarySearch(subArrB, subArrA[aLen/2])  # such that B[j] <=  A[l/2] <= B[j +1]
      t1 = Thread.new { 
        merge(
          SubArray.new(arr, 0, aLen/2 + j - 1), #result part
          SubArray.new(subArrA, 0, aLen/2 - 1), #part A
          SubArray.new(subArrB, 0, j - 1) #part B
        ) 
      }
      t2 = Thread.new { 
        merge(
          SubArray.new(arr, aLen/2 + j, totalLen - 1), #result part
          SubArray.new(subArrA, aLen/2, aLen - 1), #part A
          SubArray.new(subArrB, j, bLen - 1) #part B
        ) 
      }
      t1.join
      t2.join
    end

    post_merge(arr, subArrA, subArrB)
  end

  # returns j such that arr[j] <= elem <= arr[j +1]
  # arr is a SubArray
  # what do you do if arr.length = 1? :s
  def binarySearch (arr, elem)
    #typical binsearch :)
    return 0
  end
  
end
