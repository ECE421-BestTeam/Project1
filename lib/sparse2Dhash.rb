class Sparse2DHash
  attr_reader :rows, :cols
  def initialize(rows,cols, default=nil, &block)
    @rows = rows
    @cols = cols
    @block = block || Proc.new { default }
    @hash = Hash.new { |h,k| h[k] = Hash.new }

    # initialize empty rows
    rows.times do |x|
      self[x,0]
    end
  end
  
  def size
    return @rows, @cols
  end

  def get(i,j)
    h = @hash[i][j]
    return check_bounds(i,j) ? h : 0 unless h.nil?
    return 0
  end
  alias [] get

  def get_row(i)
    h=Hash.new{|h,k| k.between?(0, @cols-1)}
    @cols.times do |x|
      h[x] = 0
    end
    return h.merge(@hash[i])
  end

  def []=(i, j, value)
    raise IndexError.new("Index out of bound.") if !check_bounds(i,j)
    @hash[i][j] = value unless value==0
  end
  alias set []=


  def check_bounds(i, j)
    return i.between?(0, @rows-1) && j.between?(0, @cols-1)
  end
  
  def each
    @rows.times do |r|
      @cols.times do |c|
        yield self.get(r,c)
      end
    end
  end
  
  def each_sparse
    @rows.times do |r|
      yield(@hash[r]) unless @hash[r].nil?
    end
  end
  
  def each_with_index_sparse
    @rows.times do |r|
      yield(r, @hash[r]) unless @hash[r].nil?
    end
  end
  
end
