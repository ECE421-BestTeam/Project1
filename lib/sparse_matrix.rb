require 'json'
require 'Matrix'
require_relative './sparse_hash'


class SparseMatrix < Matrix 
  
  attr_accessor :rows
  attr_accessor :column_count
  attr_accessor :row_count
  
#  #+
#  #-
#  #*
#  #/
#  #determinant
#  #inverse
#  #transpose
#  #zero  

  def initialize(rows, column_count = (rows[0] || []).size, row_count = rows.size)
    @rows = rows
    @column_count = column_count
    @row_count = row_count
  end
  alias_method :new, :initialize
  
  def SparseMatrix.forceNew(rows, column_count = rows[0].size, row_count = rows.size)
    new(rows, column_count, row_count)
  end
  
  def SparseMatrix.[](*rows)
    SparseMatrix.rows(rows)
  end
    
  def SparseMatrix.rows(rows)
    rows = convert_to_array(rows)
    rows.map! do |row|
      convert_to_array(row)
    end
    # populate the hash based on rows
    newRows = SparseHash.new(rows.length)
    rows.each_with_index do |row, rowNum|
      newRows[rowNum] = SparseHash.new(row.length)
      row.each_with_index do |val, colNum|
        newRows[rowNum][colNum] = val
      end
    end
    new(newRows)
  end
  
  def SparseMatrix.columns(columns)
    SparseMatrix.rows(columns).transpose
  end
  
  def SparseMatrix.build(row_count, column_count = row_count, &block)
    # populate the hash based on a code block
    newRows = SparseHash.new(row_count)
    (0..(row_count-1)).each do |row|
      newRows[row] = SparseHash.new(column_count)
      (0..(column_count-1)).each do |col|
        newRows[row][col] = block.call(row,col)
      end
    end
    new(newRows)
  end
  
  def SparseMatrix.diagonal(*values)
	dRows = SparseHash.new(values.size)
	values.each_with_index do |val, i|
	  dRows[i] = SparseHash.new(values.size)
	  dRows[i][i] = val
	end
	new(dRows)
  end
  
  def SparseMatrix.scalar(n, value)
	sRows = SparseHash.new(n)
	(0..(n - 1)).each do |i|
	  sRows[i] = SparseHash.new(n)
	  sRows[i][i] = value
	end
	new(sRows)
  end
  
  def SparseMatrix.identity(size)
    # create a hash for an identity matrix
    SparseMatrix.scalar(size, 1)
  end
  
  def SparseMatrix.unit(size)
    # create a hash for an identity matrix
    SparseMatrix.identity(size)
  end
  
  def SparseMatrix.I(size)
    # create a hash for an identity matrix
    SparseMatrix.identity(size)
  end
  
  def SparseMatrix.zero(rows, cols = rows)
    zRows = SparseHash.new(rows)
    (0..(rows - 1)).each do |i|
      zRows[i] = SparseHash.new(cols)
    end
    new(zRows)
  end
  
  def SparseMatrix.row_vector(rows)
    row = SparseHash.new(1);
    row[0] = SparseHash.new(rows.size);
	rows.each_with_index do |val,i|
	  row[0][i] = val
	end
	new(row)
  end
  
  def SparseMatrix.column_vector(column)
    SparseMatrix.columns([column])
  end
  
  def get(i,j)
    @rows[i][j] if @rows[i]
  end
  alias [] get
  
  def set(i,j,v)
    return nil unless i.between?(0, @row_count-1) && j.between?(0, @column_count-1)
    @rows[i][j]=v
  end
  alias []= set
  
  def dimensions
    [@row_count, @column_count]
  end
  
  def +(other)
  
    if other.respond_to?(:combine)
      return self.combine(other) {|e1,e2| e1+e2}
    else
      super(other)
    end
  end

  def -(other)
    if other.respond_to?(:combine)
      return self.combine(other) {|e1,e2| e1-e2}
    else
      super(other)
    end
  end

  # Common iteration for element-element operation
  def combine(other)
    SparseMatrix.Raise ErrDimensionMismatch if other.dimensions != self.dimensions
    result = other.clone
    row_count.times {|i|
      column_count.times { |j|
        if self[i,j].nil? && result[i,j].nil?
          result[i,j] = 0
        else
          result[i,j]= yield(self[i,j],result[i,j])
        end
        }
      }
    result
  end

  def *(other)
    if other.kind_of? Numeric
      rows.map {|x| x*other}
    elsif other.respond_to?(:combine)
      super(other)
    end
  end
  
  def transpose
    puts 'Please implement jonathan! :)'
  end
  
#  cloning seems to be working on its own but sometimes it weirds out and doesn't work properly
#  def clone
#    new_matrix @rows.map(&:dup)
#  end

# Is just (matrix * thing.inverse) so it should be faster just by using our inverse+determinant functions
#  def /(thing)
#    
#  end
  
  def inverse
    det = determinant
    Matrix.Raise ErrNotRegular if det == 0
    
    a = @rows.deep_copy  #Make a deep copy!
    return SparseMatrix.I(@column_count).innerInverse(a)
  end
  
  def innerInverse(a)
    (0..(@column_count - 1)).each do |k|
      i = k
      akk = a[k][k].abs
      ((k + 1)..(@column_count - 1)).each do |j|
        v = a[j][k].abs
        if v > akk
          i = j
          akk = v
        end
      end
      Matrix.Raise ErrNotRegular if akk == 0
      if i != k
        a[i], a[k] = a[k], a[i]
        @rows[i], @rows[k] = @rows[k], @rows[i]
      end
      akk = a[k][k]

      (0..(@column_count - 1)).each do |ii|
        next if ii == k
        q = a[ii][k].quo(akk)
        a[ii][k] = 0

        ((k + 1)..(@column_count - 1)).each do |j|
          a[ii][j] -= a[k][j] * q
        end
        (0..(@column_count - 1)).each do |j|
          @rows[ii][j] -= @rows[k][j] * q
        end
      end

      ((k + 1)..(@column_count - 1)).each do |j|
        a[k][j] = a[k][j].quo(akk)
      end
      (0..(@column_count - 1)).each do |j|
        @rows[k][j] = @rows[k][j].quo(akk)
      end
    end
    self
  end
  
  def determinant
    SparseMatrix.Raise ErrDimensionMismatch if (@column_count != @row_count)

    return innerDeterminant()
  end
  
  # x, y - the coords of the previous coefficient
  # cols - data about the cols being considered (or the range [inclusive] to consider)
  def innerDeterminant(x = -1, ys = [])
    x += 1 # new coefficient will be on this row
    if (x == @row_count - 1) # we have reached the lowest level
      index = (0..x).find() {|n| !(ys.include? n) }
      return @rows[x][index]
    end
    
    result = 0
    op = -1
    @rows[x].each_sparse do |colNum, val|
      if (!(ys.include? colNum))
        op = op * -1
        if (val != 0)
          temp = ys.dup
          result += op * val * innerDeterminant(x, temp.push(colNum))
        end
      end
    end
    
    return result
  end

  def to_s
    if empty?
      "#{self.class}.empty(#{row_count}, #{column_count})"
    else
      "#{self.class}[" + @rows.collect{|row|
        "[" + row.collect{|e| e.to_s}.join(", ") + "]"
      }.join(", ")+"]"
    end
  end
end