require 'Matrix'
require './sparse2Dhash.rb'


class SparseMatrix < Matrix 
  
  attr_accessor :rows
  attr_accessor :column_count
  attr_accessor :row_count
  
  
  
#  +
#  -
#  *
#  /
#  determinant
#  inverse
#  transpose
#  zero    
  def dimensions
    @row_count, @column_count
  end

  def +(other)

      
    case m
      when Numeric
        Matrix.Raise ErrOperationNotDefined, "+", self.class, m.class
      when Vector
        m = self.class.column_vector(m)
      when Matrix
      else
      return apply_through_coercion(m, __method__)
    Sparse2DHash.new(row_count,col_count) {
    @row_count.times do |r|
      @col_count.times do |c|
        h[r,c] = self[r,c] + other[r,c]
      end
    end
    h
  end
    

  end

  
  def determinant()
    if (@column_count != @row_count)
      SparseMatrix.Raise ErrDimensionMismatch
    end
    
    # build cols
    cols = {}
    (0..@column_count - 1).each do |val|
      if (val % 2 == 0)
        cols[val] = :+
      else
        cols[val] = :-
      end
    end

    return innerDeterminant(-1, @column_count, cols)
  end
  
  # x, y - the coords of the previous coefficient
  # cols - data about the cols being considered
  private
  def innerDeterminant(x, y, cols)
    # create the new cols
    newCols = {}
    cols.each_sparse do |entry|
      colNum = entry[0]
      op = entry[1]
      if (colNum < y)
        newCols[colNum] = op
      elsif (colNum > y)
          if (op == :+)
            newCols[colNum] = :-
          else
            newCols[colNum] = :+
          end
      end
    end
    
    x += 1 # new coefficient will be on this row
    
    if (newCols.length == 1) # we have reached the lowest level
      newCols.each_sparse do |entry|
        colNum = entry[0] 
        return @rows[x][colNum]
      end
    end
    
    result = 0
    newCols.each_sparse do |entry|
      colNum = entry[0]
      op = entry[1]
      temp = @rows[x][colNum] * innerDeterminant(x, colNum, newCols)
      if (op == :+)
        result += temp
      else
        result -= temp
      end
    end
    return result
  end

end