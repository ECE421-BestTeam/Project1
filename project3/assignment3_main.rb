# Christina Ho
# Lindsay Livojevic
# Jonathan Ohman

require_relative './lib/merge-sort'
include MergeSort

a1 = [1,3,2]
a2 = [[0], [0,0,0], [0,0]]

sortInPlace(a1, 0)

#Merge sort is called by MergeSort's sortInPlace method: sortInPlace(<array>, <timeout>) { <optional comparator block }
#If the timeout is set to 0, it can run indefinitely, but a nonzero timeout will stop the sort at that elapsed time.

sortInPlace(a1, 0) do |a,b|
  b <=> a
end
#If a code block is specified, it takes the place of the standard comparator.
#The example above will sort in the opposite order of the previous example.

sortInPlace(a2, 0) do |a,b|
  a.length <=> b.length
end
#This example will sort the arrays in ascending order of length.