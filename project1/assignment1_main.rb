# Christina Ho
# Lindsay Livojevic
# Jonathan Ohman

require './lib/matrix_factory'
require './lib/sparse_matrix'

puts "MatrixFactory.rows(Matrix, [[1,2],[3,4]]): #{MatrixFactory.rows(Matrix, [[1,2],[3,4]])}"
puts "MatrixFactory.rows(SparseMatrix, [[1,2],[3,4]]): #{MatrixFactory.rows(SparseMatrix, [[1,2],[3,4]])}"
puts "SparseMatrix[[1,2],[3,4]]: #{SparseMatrix[[1,2],[3,4]]}"

require_relative ‘sparse_matrix’

# How to create matrices
denseMatrix = MatrixFactory.rows(Matrix, [[1,0,3],[2,2,0],[0,0,0]])
sparseMatrix1 = MatrixFactory.rows(SparseMatrix, [[1,0,3],[2,2,0],[0,0,0]])
sparseMatrix2 = MatrixFactory.build(3,3)  do |row, col| 
row==col ? row+col  : 0
end

# Operations

addResult = sparseMatrix1 + sparseMatrix2

subResult = sparseMatrix1 - sparseMatrix2

mulResult = sparseMatrix1*sparseMatrix2

divResult = sparseMatrix1/sparseMatrix2

sparseDeterm = sparseMatrix1.det