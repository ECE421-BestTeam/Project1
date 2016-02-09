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

  # Rows should be an array
  def initialize(rows, column_count = (rows[0] || []).size, row_count = rows.size)
    case rows
      when Array
        # populate the hash based on rows
        newRows = SparseHash.new(rows.length)
        rows.each_with_index do |row, rowNum|
          newRows[rowNum] = SparseHash.new(row.length)
          row.each_with_index do |val, colNum|
            newRows[rowNum][colNum] = val
          end
        end
        @rows = newRows
      when SparseHash
        @rows = rows
      end
    
    @column_count = column_count
    @row_count = row_count
  end
  alias_method :new, :initialize
  
  def SparseMatrix.[](*rows)
    SparseMatrix.rows(rows)
  end
    
  def SparseMatrix.rows(rows)
    rows = convert_to_array(rows)
    rows.map! do |row|
      row = convert_to_array(row)
    end
    new(rows)
  end
  
  def SparseMatrix.columns(columns)
    SparseMatrix.rows(columns).transpose
  end
  
  def SparseMatrix.build(row_count, column_count = row_count, &block)
    # populate the hash based on a code block
    newRows = []
    (0..(row_count-1)).each do |row|
      newRows[row] = []
      (0..(column_count-1)).each do |col|
        newRows[row][col] = block.call(row,col)
      end
    end
    SparseMatrix.rows(newRows)
  end
  
  def SparseMatrix.diagonal(*values)
    n = values.length
    rows = []
    (0..(n - 1)).each do |i|
      temp = Array.new(n, 0)
      temp[i] = values[i]
      rows.push(temp)
    end
    new(rows)
  end
  
  def SparseMatrix.scalar(n, value)
    sRows = []
    (0..(n - 1)).each do |i|
      temp = Array.new(n, 0)
      temp[i] = value
      sRows.push(temp)
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
    zRows = []
    (0..(rows - 1)).each do |i|
      zRows[i] = Array.new(cols, 0)
    end
    new(zRows, cols)
  end
  
  def SparseMatrix.row_vector(row)
    new([row])
  end
  
  def SparseMatrix.column_vector(column)
    SparseMatrix.columns([column])
  end
  
  def get(i,j)
    return (@rows[i].nil? || @rows[i][j].nil?) ? 0  : @rows[i][j]
  end
  alias [] get
  alias element get
  
  def set(i,j,v)
    return nil unless i.between?(0, @row_count-1) && j.between?(0, @column_count-1)
    @rows[i][j]=v
  end
  alias []= set
  
  def dimensions
    [@row_count, @column_count]
  end
  
  def zero?
	@rows.each do |row|
	  return false unless row.hashsize == 0
	end
	return true
  end
  
  def +(other)
    if other.respond_to?(:combine)
      self.combine(other) {|e1, e2| e1 + e2 }

    else
      super(other)
    end
  end

  def -(other)
    if other.respond_to?(:combine)
      return self.combine(other) {|e1,e2| e1 - e2}
    else
      super(other)
    end
  end

  # Common iteration for element-element operation
  def combine(other)
    SparseMatrix.Raise ErrDimensionMismatch if other.dimensions != self.dimensions

    result = self.deep_copy
    other.rows.each_sparse { |r, row|
      row.each_sparse {|c, col|
        result[r,c] = yield(self[r,c],other[r,c])
      }
    }
    result
  end
  
  def deep_copy
    result = self.clone
    result.rows = self.rows.deep_copy
    return result
  end

  def *(other)
    if other.kind_of? Numeric
      rows = @rows.collect {|row|
        row.collect {|e| e * other}
      }
      return new_matrix rows
    elsif other.kind_of?Vector
      other = self.class.column_vector(other)
      r = self * other
      return r.column(0)
    else
      return super(other)
    end
  end
  
  def transpose
    newMatrix = SparseMatrix.zero(@column_count, @row_count)
    rows.each_with_index do |row, rowNum|
      row.each_with_index do |val, colNum|
        newMatrix.set(colNum, rowNum, val)
      end
    end
    return newMatrix
  end
  
#  cloning seems to be working on its own but sometimes it weirds out and doesn't work properly
#  def clone
#    new_matrix @rows.map(&:dup)
#  end

  
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
  
  def inspect
    self.to_s
  end
  
  def to_a
    result = @rows.to_ary
    result.each_with_index do |val, i|
      result[i] = val.to_ary
    end
    return result
  end
end