require_relative './merge-sort-contract'

module MergeSort
  include MergeSortContract

  def sortInPlace (arr, duration)
    # do something funky with timing
    mergeSort(arr, 0, arr.length)
    # break out if timing got funky
  end

  def mergeSort (arr, p, r)
    #make sure you call merge with the subArrs being deepCopies.  
    #There is an option for that on init SubArray.new(arr, start, end, true)
  end
  
  # Merges subArrA and 2 onto arr (C)
  # arr should carry through (pass by ref)
  # the subArr should be a deep copy though... 
  # Maybe only required to deep copy when coming in from mergeSort
  def merge (arr, subArrA, subArrB)
    pre_merge(arr, subArrA, subArrB)

    l = aLen = subArrA.length
    m = bLen = subArrB.length
    n = totalLen = aLen + bLen
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