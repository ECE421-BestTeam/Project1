# Christina Ho
# Lindsay Livojevic
# Jonathan Ohman

require './lib/matrix_factory'
require './lib/sparse_matrix'

puts "MatrixFactory.rows(Matrix, [[1,2],[3,4]]): #{MatrixFactory.rows(Matrix, [[1,2],[3,4]])}"
puts "MatrixFactory.rows(SparseMatrix, [[1,2],[3,4]]): #{MatrixFactory.rows(SparseMatrix, [[1,2],[3,4]])}"
puts "SparseMatrix[[1,2],[3,4]]: #{SparseMatrix[[1,2],[3,4]]}"