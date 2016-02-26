require 'test/unit/assertions'
require_relative './sub-array'

module SubArrayContract
  include Test::Unit::Assertions

  def class_invariant(arrRef, start, final, length)
    assert arrRef.class == Array, "arr must be of type Array"
    assert start.class == Fixnum && start >= 0, "start should be greater than or equal to 0"
    assert final.class == Fixnum && final >= 0, "final should be greater than or equal to 0"
    assert final < arrRef.length, "final should be within original arr bounds"
    assert length.class == Fixnum && length >= 0, "length should be greater than or equal to 0"
  end
  
  def pre_initialize(arr, start, final)
    assert arr.class == Array || arr.class == SubArray, "arr must be of type Array or SubArray"
    assert start.class == Fixnum && start >= 0, "start should be greater than or equal to 0"
    assert final.class == Fixnum && final >= 0, "final should be greater than or equal to 0"
  end
  
  def post_initialize(arr, start, final)
  end
  
  def pre_accessor(i)
    assert i.class == Fixnum, "i should be an integer"
    assert i >= 0 && i < length, "Out of Bounds."
  end

  def post_accessor(i)
  end
  
  def pre_setter(i, val)
    post_accessor(i)
  end

  def post_setter(i, val)
    post_accessor(i)
  end
  
  
end