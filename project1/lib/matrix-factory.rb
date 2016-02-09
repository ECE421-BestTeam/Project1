class MatrixFactory
  # Define all matrix creation methods
  # eg. MatrixFactory.rows(MatrixTypeClass, args)
  
  $methods = [
    :[],
    :rows,
    :columns,
    :build,
    :diagonal,
    :scalar,
    :identity,
    :unit,
    :I,
    :zero,
    :rowVector,
    :columnVector
  ]  

  $methods.each do |methodName|
    define_singleton_method(methodName) do |*args, &block|
      matrixClass = args.delete_at(0)
      if (matrixClass == Matrix || matrixClass == SparseMatrix)
        case methodName
        when :rowVector
          methodName = :row_vector
        when :columnVector
          methodName = :column_vector
        end
        return matrixClass.send(methodName, *args, &block)
      else
        raise TypeError
      end
    end
  end
 
end
