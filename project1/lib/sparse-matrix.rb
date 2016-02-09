require 'json'
require 'Matrix'
require_relative './sparse-hash'


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

  #
  # Matrix.new is private; use Matrix.rows, columns, [], etc... to create.
  #
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
  
  # Creates a matrix where each argument is a row.
  #   Matrix[ [25, 93], [-1, 66] ]
  #      =>  25 93
  #          -1 66
  #
  def SparseMatrix.[](*rows)
    SparseMatrix.rows(rows)
  end
    
  # Creates a matrix where +rows+ is an array of arrays, each of which is a row
  # of the matrix.  If the optional argument +copy+ is false, use the given
  # arrays as the internal structure of the matrix without copying.
  #   Matrix.rows([[25, 93], [-1, 66]])
  #      =>  25 93
  #          -1 66
  #
  def SparseMatrix.rows(rows)
    rows = convert_to_array(rows)
    rows.map! do |row|
      row = convert_to_array(row)
    end
    new(rows)
  end
  
  # Creates a matrix using +columns+ as an array of column vectors.
  #   Matrix.columns([[25, 93], [-1, 66]])
  #      =>  25 -1
  #          93 66
  #
  def SparseMatrix.columns(columns)
    SparseMatrix.rows(columns).transpose
  end
  
  # Creates a matrix of size +row_count+ x +column_count+.
  # It fills the values by calling the given block,
  # passing the current row and column.
  # Returns an enumerator if no block is given.
  #
  #   m = Matrix.build(2, 4) {|row, col| col - row }
  #     => Matrix[[0, 1, 2, 3], [-1, 0, 1, 2]]
  #   m = Matrix.build(3) { rand }
  #     => a 3x3 matrix with random elements
  #
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
  
  # Creates a matrix where the diagonal elements are composed of +values+.
  #   Matrix.diagonal(9, 5, -3)
  #     =>  9  0  0
  #         0  5  0
  #         0  0 -3
  #
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
  
  # Creates an +n+ by +n+ diagonal matrix where each diagonal element is
  # +value+.
  #   Matrix.scalar(2, 5)
  #     => 5 0
  #        0 5
  #
  def SparseMatrix.scalar(n, value)
    sRows = []
    (0..(n - 1)).each do |i|
      temp = Array.new(n, 0)
      temp[i] = value
      sRows.push(temp)
    end
    new(sRows)
  end
  
  # Creates an +n+ by +n+ identity matrix.
  #   Matrix.identity(2)
  #     => 1 0
  #        0 1
  #
  def SparseMatrix.identity(size)
    # create a hash for an identity matrix
    SparseMatrix.scalar(size, 1)
  end
  class << SparseMatrix
    alias unit identity
    alias I identity
  end
  
  # Creates a zero matrix.
  #   Matrix.zero(2)
  #     => 0 0
  #        0 0
  #
  def SparseMatrix.zero(rows, cols = rows)
    zRows = []
    (0..(rows - 1)).each do |i|
      zRows[i] = Array.new(cols, 0)
    end
    new(zRows, cols)
  end
  
  # Creates a single-row matrix where the values of that row are as given in
  # +row+.
  #   Matrix.row_vector([4,5,6])
  #     => 4 5 6
  #
  def SparseMatrix.row_vector(row)
    new([row])
  end
  
  # Creates a single-column matrix where the values of that column are as given
  # in +column+.
  #   Matrix.column_vector([4,5,6])
  #     => 4
  #        5
  #        6
  #
  def SparseMatrix.column_vector(column)
    SparseMatrix.columns([column])
  end
  
  # gets an element from the matrix
  def get(i,j)
    return (@rows[i].nil? || @rows[i][j].nil?) ? 0  : @rows[i][j]
  end
  alias [] get
  alias element get
  
  # sets an element in the matrix
  def set(i,j,v)
    return nil unless i.between?(0, @row_count-1) && j.between?(0, @column_count-1)
    @rows[i][j]=v
  end
  alias []= set
  
  # returns the dimensions of the matrix
  def dimensions
    [@row_count, @column_count]
  end
  
  # Returns +true+ is this is a matrix with only zero elements
  #
  def zero?
	@rows.each do |row|
	  return false unless row.hashsize == 0
	end
	return true
  end
  
  # Handles Matrix addition and forwards the rest to super
  #   Matrix.scalar(2,5) + Matrix[[1,0], [-4,7]]
  #     =>  6  0
  #        -4 12
  #
  def +(other)
    if other.respond_to?(:combine)
      self.combine(other) {|e1, e2| e1 + e2 }

    else
      super(other)
    end
  end

  # Handles Matrix subtraction and forwards the rest to super
  #   Matrix[[1,5], [4,2]] - Matrix[[9,3], [-4,1]]
  #     => -8  2
  #         8  1
  #
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

    result = self.clone
    other.rows.each_sparse { |r, row|
      row.each_sparse {|c, col|
        result[r,c] = yield(self[r,c],other[r,c])
      }
    }
    result
  end
  
  # returns a deep copy of self
  def deep_copy
    result = self.clone
    result.rows = self.rows.deep_copy
    return result
  end

  # Handles multiplication with a number, vector, or matrix.
  # Multiplies the vector by +x+, where +x+ is a number or another vector.
  # Matrix multiplication.
  #   Matrix[[2,4], [6,8]] * Matrix.identity(2)
  #     => 2 4
  #        6 8
  #
  #
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
    elsif other.kind_of? Matrix
      SparseMatrix.Raise ErrDimensionMismatch if column_count != other.row_count
      result = SparseHash.new(@row_count)
      result.each_with_index do |v, i|
        result[i] = SparseHash.new(other.column_count)
      end
      @rows.each_sparse do |rowNum, row|
        0.upto(other.column_count - 1) do |i|
          temp = 0
          row.each_sparse do |colNum, val|
            temp += val * other[colNum, i]
          end
          result[rowNum][i] = temp
        end
      end
      return new_matrix result
    else
      return super(other)
    end
  end
  
  # Returns the transpose of the matrix.
  #   Matrix[[1,2], [3,4], [5,6]]
  #     => 1 2
  #        3 4
  #        5 6
  #   Matrix[[1,2], [3,4], [5,6]].transpose
  #     => 1 3 5
  #        2 4 6
  #
  def transpose
    newRows = SparseHash.new(column_count)
    0.upto(column_count - 1).each do |i|
      newRows[i] = SparseHash.new(row_count)
    end
    rows.each_sparse do |i,row|
      row.each_sparse do |j,val|
        newRows[j][i]=val
      end
    end
    return new_matrix newRows, row_count
  end
  
  # Returns the determinant of the matrix.
  #
  # Beware that using Float values can yield erroneous results
  # because of their lack of precision.
  # Consider using exact types like Rational or BigDecimal instead.
  #
  #   Matrix[[7,6], [3,9]].determinant
  #     => 45
  #
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

  # converts self to representitive string
  def to_s
    if empty?
      "#{self.class}.empty(#{row_count}, #{column_count})"
    else
      "#{self.class}[" + @rows.collect{|row|
        "[" + row.collect{|e| e.to_s}.join(", ") + "]"
      }.join(", ")+"]"
    end
  end
  
  # returns the to_s of self
  def inspect
    self.to_s
  end
  
  # converts the matrix into an array
  def to_a
    result = @rows.to_ary
    result.each_with_index do |val, i|
      result[i] = val.to_ary
    end
    return result
  end
end