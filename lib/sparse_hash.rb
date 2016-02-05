class SparseHash < Hash
  attr_reader :size

  def initialize (size, default = nil, &block)
    @size = size
    super() { |h,k| k.between?(0, @size-1) ? block.call(h,k) : nil}
    self
  end

  def get(i)
    self[i].nil? && block_given? ? yield(i) : self[i]
  end
  
  def each
    (0...size).each do |i|
      yield self[i]
    end
  end
  
  def map
    (0..size).map do |i|
      yield self[i]
    end
  end

end # end of SparseHash