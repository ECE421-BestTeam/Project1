require_relative './sub-array-contract'

class SubArray
  include SubArrayContract
  
  attr_reader :arrRef
  attr_reader :start
  attr_reader :end
  attr_reader :length
  
  def initialize (arr, start = 0, final = arr.length - 1)
    pre_initialize(arr, start, final)
    if arr.class == SubArray
      @arrRef = arr.arrRef
      @start = start + arr.start
      @final = final + arr.start
      @length = [final - start + 1, 0].max
    else
      @arrRef = arr
      @start = start
      @final = final
      @length = [final - start + 1, 0].max
    end
    class_invariant(@arrRef, @start, @final, @length)
    post_initialize(arr, start, final)
  end

	def [] (i)
    pre_accessor(i)
		@arrRef[@start + i]
    post_accessor(i)
	end

  def []= (i, newVal)
    pre_setter(i, newVal)
		@arrRef[@start + i] = newVal
    post_setter(i, newVal)
	end
  
	def length
		return @length
	end
 
  def to_s
    result = "["
    (0 .. @length - 2).each do |i|
      result += @arrRef[i].to_s + ", "
    end
    result += @arrRef[@length -1].to_s + "]"
    return result
  end
end
