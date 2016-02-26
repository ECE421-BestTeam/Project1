require 'test/unit/assertions'
require_relative './sub-array'

module MergeSortContract
  include Test::Unit::Assertions
  # Module, so no class invariant

  def pre_merge(arr, subArr1, subArr2)
    assert arr.class == Array, "arr must be of type Array"
    assert subArr1.class == SubArray, "subArr1 must be of type SubArray"
    assert subArr2.class == SubArray, "subArr2 must be of type SubArray"
    assert subArr1.length + subArr2.length <= arr.length, "subArr's lengths must not total greater than arr.len"
  end
  
  def post_merge(arr, subArr1, subArr2)
    assert arr.class == Array, "arr must be an array"
  end

end