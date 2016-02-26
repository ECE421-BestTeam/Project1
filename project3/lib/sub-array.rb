require_relative './sub-array-contract'

class SubArray
  include SubArrayContract
  
  attr_reader :arrRef
  attr_reader :start
  attr_reader :end
  attr_reader :length
  
  def initialize (arr, start = 0, final = arr.length - 1, deepCopy = false)
    pre_initialize(arr, start, final, deepCopy)

    if deepCopy
      copyArr = []
      (start..final).each do |i|
        copyArr.push(arr[i])
      end
      @arrRef = copyArr
      @start = 0
      @length = copyArr.length
      @final = @length - 1
    else
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
    end
    
    class_invariant(@arrRef, @start, @final, @length)
    post_initialize(arr, start, final, deepCopy)
  end

	def [] (i)
    pre_accessor(i)
		return @arrRef[@start + i]
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
    (0 .. @length - 1).each do |i|
      result += @arrRef[i].to_s
      if i != @length - 1
        result += ", "
      end
    end
    result += "]"
    return result
  end
  
  def each_index (&block)
    (0..@length - 1).each do |i|
      block.call(i)
    end
  end

end