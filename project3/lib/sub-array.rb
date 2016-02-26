class SubArray

  def initialize (arr, start = 0, endd = arr.length - 1)
    @arrRef = arr
    @start = start
    @end = endd
    @length = endd - start + 1
  end

	def [] (i)
    #plus maybe some error handling, bounds checking
		@arrRef[@start + i]
	end

  def []= (i, newVal)
    #plus maybe some error handling, bounds checking
		@arrRef[@start + i] = newVal
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
