require 'json'
require 'Matrix'
require_relative 'sparse_hash'


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

  def initialize(rows, column_count = rows[0].size, row_count = rows.size)
    @rows = rows
    @column_count = column_count
    @row_count = row_count
    self
  end
  alias_method :new, :initialize
  
  def SparseMatrix.forceNew(rows, column_count = rows[0].size, row_count = rows.size)
    new(rows, column_count, row_count)
  end
  
  def SparseMatrix.identity(size)
    iRows = SparseHash.new(size)
    (0..(size - 1)).each do |i|
      iRows[i] = SparseHash.new(size)
      iRows[i][i] = 1
    end
    new(iRows)
  end
#  class << Matrix
#    alias unit identity
#    alias I identity
#  end
    
  def SparseMatrix.rows(rows)
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
  
  def dimensions
    [@row_count, @column_count]
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
  
  def +(other)
    if other.respond_to?(:combine)
      self.combine(other) {|e1,e2| e1+e2}
    else
      super(other)
    end
  end

  def -(other)
    if other.respond_to?(:combine)
      self.combine(other) {|e1,e2| e1-e2}
    else
      super(other)
    end
  end

  # Common iteration for element-element operation
  def combine(other)
    SparseMatrix.Raise ErrDimensionMismatch if other.dimensions != self.dimensions
    result = SparseMatrix.rows(rows)
    rows.each_pair do |i,column|
      column.each_pair do |j, __|
        result[i,j] = yield(self[i,j], other[i,j])
      end
    end
    result
  end

  def *(other)
    if other.kind_of? Numeric
      rows.map {|x| x*other}
    elsif other.kind_of? Matrix
      super(other)
    end
  end

# Is just (matrix * thing.inverse) so it should be faster just by using our inverse+determinant functions
#  def /(thing)
#    
#  end
  
  def inverse
    det = determinant
    Matrix.Raise ErrNotRegular if det == 0
    
    a = @rows.deep_copy  #Make a deep copy!
    
    b = SparseMatrix.identity(@column_count)
    b.innerInverse(a)
  end
    
  def determinant()
    if (@column_count != @row_count)
      SparseMatrix.Raise ErrDimensionMismatch
    end
    
    return innerDeterminant(-1, @column_count, (0..@column_count - 1))
  end
  
  # x, y - the coords of the previous coefficient
  # cols - data about the cols being considered (or the range [inclusive] to consider)
  def innerDeterminant(x, y, cols)
    # create the new cols
    newCols = {}
    if (cols.class == Range) 
      # We need to create a fresh newCols
      cols.each do |colNum|
        if (colNum < y)
          if (colNum % 2 == 0)
            newCols[colNum] = :+
          else
            newCols[colNum] = :-
          end
        elsif (colNum > y)
          if (colNum % 2 == 0)
            newCols[colNum] = :-
          else
            newCols[colNum] = :+
          end
        end
      end        
    else
      # We need to modify newCols from existing cols
      cols.each do |entry|
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
    end
    
    x += 1 # new coefficient will be on this row
    
    if (newCols.length == 1) # we have reached the lowest level
      newCols.each do |entry|
        colNum = entry[0] 
        return @rows[x][colNum]
      end
    end
    
    result = 0
    newCols.each do |entry|
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
  
end