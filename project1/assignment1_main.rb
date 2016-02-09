# Christina Ho
# Lindsay Livojevic
# Jonathan Ohman

require_relative './lib/sparse-matrix'
require_relative './lib/matrix-factory'

# How to create matrices
denseMatrix = MatrixFactory.rows(Matrix, [[1,0,3],[2,2,0],[0,0,0]])
sparseMatrix1 = MatrixFactory.rows(SparseMatrix, [[1,0,3],[2,2,0],[0,0,3]])
sparseMatrix2 = MatrixFactory.build(SparseMatrix, 3,3)  do |row, col| 
  row == col ? row + col : 0
end
zeroMatrix = MatrixFactory.zero(SparseMatrix, 3)


# Operations

addResult = sparseMatrix1 + sparseMatrix2

subResult = sparseMatrix1 - sparseMatrix2

mulResult = sparseMatrix1 * sparseMatrix2

divResult = sparseMatrix2 / sparseMatrix1

sparseDeterm = sparseMatrix1.determinant

sparseInverse = sparseMatrix1.inverse

zeroTest1 = sparseMatrix1.zero?

zeroTest2 = zeroMatrix.zero?

trResult = sparseMatrix1.transpose