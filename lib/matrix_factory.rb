class MatrixFactory
  # Define all matrix creation methods
  # eg. MatrixFactory.rows(MatrixTypeClass, args)
  
#  ::[]
#  ::rows(rows, copy = true)
#  ::columns
#  ::build(row_count, #column_count, &block)
#  ::diagonal
#  ::scalar(n, value)
#  ::identity
#  ::unit
#  Matrix.I(n)
#  ::zero
#  ::row_vector
#  ::column_vector

  def self.rows (matrixClassType, rowsArr) 
    if (matrixClassType == Matrix || matrixClassType == SparseMatrix)
      return matrixClassType.rows(rowsArr)
    else
      raise TypeError
    end
  end

end