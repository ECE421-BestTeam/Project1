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
  
  # Merges subArr1 and 2 onto arr
  def merge (arr, subArr1, subArr2)
    pre_merge(arr, subArr1, subArr2)


    post_merge(arr, subArr1, subArr2)
  end

  # returns j such that arr[j] <= elem <= arr[j +1]
  def binarySearch (arr, elem)
    #typical binsearch :)
    return j
  end
  
end
