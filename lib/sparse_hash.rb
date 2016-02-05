class SparseHash < Hash
  attr_reader :size

  def initialize (rows, cols, default = nil, &block)
    @rows = rows
    @cols = cols
    @block = block || Proc.new { default }
    
    super() { |h,r| r.between?(0, @rows-1) ? @block.call(h,r) : nil}
  end

  def get(row, col)
    self[row][col].nil? && block_given? ? yield(i) : self[i]
  end
  
  def each
    return to_enum :each unless block_given?
    (0...size).each do |i|
      yield self[i]
    end
  end
  
  def map
    return to_enum :each unless block_given?
    (0..size).map do |i|
      yield self[i]
    end
  end

end # end of SparseHash