class SparseHash < Hash
  attr_reader :size
  
  def initialize (size, default = nil, &block)
    @size = size #max size of hash table
    @block = block || Proc.new { default }
    super() { |h,k| k.between?(0,@size-1) ? @block.call(h,k) : nil}
  end #end init
  
  # Returns the hash table length
  def hashsize
    
    self.length
  end
  
  # Returns element at index i, 0 if within bounds but no entry exists,
  # or nil otherwise.
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
  
  # Sets hash element as value v with index i unless v is zero or i is out of bounds.
  def []=(i,v)
    return if !check_bound(i)
    super(i,v) unless v==0
	delete(i) if v==0
  end
  alias set []=
  
  # Iterates through the fixed maximum size, including 'zero' entries.
  def each
    @size.times do |i|
      yield self[i]
    end
  end
  
  # Iterate through only 'non-zero' hash entries
  def each_sparse
    self.keys.each do |i|
      yield i, self[i]
    end
  end
  
  # Map for maximum size of hash, returns hash
  def map
    result = SparseHash.new(size)
    @size.times do |i|
      result[i] = yield(self[i])
    end
    result
  end
  
  # Map for only existing hash entries, returns hash
  def map_sparse
    result = SparseHash.new(size)
    self.each_sparse do |i|
      result[i] = yield(i)
    end
    result
  end
 
  # Collect for entire hash, returns array
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
  
  # Creates a deep copy of all elements and returns a disassociated hash
  def deep_copy
    result = SparseHash.new(self.size)
    self.each_pair do |i, v|
      if (v.class == SparseHash)
        result[i] = v.deep_copy
      else
        result[i] = v
      end
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