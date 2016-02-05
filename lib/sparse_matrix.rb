require 'Matrix'

class SparseMatrix < Matrix 

#  +
#  -
#  *
#  /
#  determinant
#  inverse
#  transpose
#  zero

  attr_accessor :rows
  attr_accessor :column_count
  attr_accessor :row_count
  
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