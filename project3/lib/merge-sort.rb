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
      halfB = [bLen - 1, 0].max / 2
      j = binarySearch(subArrA, subArrB[bLen/2])  # such that A[j] <=  B[l/2] <= A[j +1]
      t1 = Thread.new { 
        merge(
          SubArray.new(arr, 0, [halfB + j + 1, 0].max), #result part
          SubArray.new(subArrA, 0, [j, 0].max), #part A
          SubArray.new(subArrB, 0, [halfB, 0].max) #part B
        ) 
      }
      t2 = Thread.new { 
        merge(
          SubArray.new(arr, [halfB + j + 2, 0].max, [totalLen - 1, 0].max), #result part
          SubArray.new(subArrA, [j + 1, 0].max , [aLen - 1, 0].max), #part A
          SubArray.new(subArrB, halfB + 1, [bLen - 1, 0].max) #part B
        ) 
      }
      t1.join
      t2.join
    end
    
    post_merge(arr, subArrA, subArrB)
  end

  # returns j such that arr[j] <= elem <= arr[j +1]
  # arr is a SubArray or Array
  def binarySearch (arr, elem)
    arr.each_index do |j| 
      if arr[j] >= elem
        return [j - 1, 0].max
      end
    end
    
    # else return the last index
    return [arr.length - 1, 0].max
  end
  
end