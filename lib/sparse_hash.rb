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

  def [](i)
    return check_bound(i) && !has_key?(i) ? 0 : super(i)
#    super(i)
  end
  alias get []
  
  def []=(i,v)
    return if !check_bound(i) || v==0
    super(i,v)
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
  alias_method :collect, :map
  
  
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