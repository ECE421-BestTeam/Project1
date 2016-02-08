class SparseHash < Hash
  attr_reader :size

  def initialize (size, default = nil, &block)
    @size = size
    @block = block || Proc.new { default }
#    super()
    super() { |h,k| k.between?(0,@size-1) ? @block.call(h,k) : nil}
  end #end init
  
  def hashsize
    self.length
  end #end hashsize

  def [](i, rangeSize = false)
    if (!rangeSize)
      return check_bound(i) && !has_key?(i) ? 0 : super(i)
    else
       result = []
      (i..(i + rangeSize - 1)).each do |i| 
        result.push(self[i])
      end
      return result
    end
  end
  alias get []
  
  def []=(i,v)
    return if !check_bound(i)
    super(i,v) unless v==0
	delete(i) if v==0
  end
  alias set []=
  
  def each
    @size.times do |i|
      yield self[i]
    end
  end
  
  def each_sparse
    self.keys.each do |i|
      yield i, self[i]
    end
  end
  
  def map
    result = SparseHash.new(size)
    @size.times do |i|
      result[i] = yield(self[i])
    end
    result
  end
  
  def collect
    result = []
    @size.times do |i|
      result.push(yield(self[i]))
    end
    result
  end
  
  def check_bound(i)
    return i.between?(0, @size-1)
  end
  
  def deep_copy (item = self)
    result = SparseHash.new(item.size)
    item.each_pair do |i, v|
      if (v.class == SparseHash)
        v = deep_copy(v)
      end
      result[i] = v
    end
    return result
  end
  
  def join (sep)
    result = ''
    @size.times do |i| 
      result += self[i]
      if (i != @size - 1)
        result += sep
      end
    end
    return result
  end
  
  def to_ary
    result = []
    @size.times do |i| 
      result.push(self[i])
    end
    return result
  end

end # end of SparseHash