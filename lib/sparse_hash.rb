class SparseHash < Hash
  attr_reader :size

  def initialize (size, default = nil, &block)
    @size = size
    @block = block || Proc.new { default }
    
    super() { |h,k| @block.call(h,k)}
  end
  
  def hashsize
    self.length
  end

  def [](i)
    return !has_key?(i) && check_bound(i) ? 0 :
    super(i).nil? && block_given? ? yield(i) : super(i)
  end
  alias get []
  
  def []=(i,v)
    super(i,v) unless v==0
  end
  alias set []=
  
  def each
    @size.times do |i|
      yield self[i]
    end
  end
  
  def each_sparse
    self.each_pair do |i,v|
      yield (v)
    end
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
  
  def join (str)
    self.to_s + str
  end

end # end of SparseHash