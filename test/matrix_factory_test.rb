# Tests that the factory produces the correct type of matrix

require 'test/unit'
require 'Matrix'
require '../lib/sparse_matrix'
require '../lib/matrix_factory'

class MatrixFactoryTest < Test::Unit::TestCase

  # Checks that the matrix matches the expected array
  # #expectedArray - an array of rows (which are arrays)
  # #matrix - a sparse or dense matrix to check
  def checkMatrix(expectedArray, matrix)
    # check number of rows
    assert_equal(matrix.row_count, expectedArray.size)
    
    # Test that each element is correct
    expectedArray.each_with_index { |row, rowNum| 
      # Test that each column is also the correct size
      assert_equal(row.size, matrix.column_count)
      row.each_with_index { |val, colNum| 
        assert_equal(val, matrix.element(rowNum, colNum))
      } 
    }
  end
  
  # Tests the passed function block, 
  # which should be a MatrixFactory creation function
  def creationTest(expectedArray, &function)
    # Matrix
    dm = function.call(Matrix)
    assert_instance_of(Matrix, dm)
    checkMatrix(expectedArray, dm)
    
    # SparseMatrix
    sm = function.call(SparseMatrix)
    assert_instance_of(SparseMatrix, sm)
    checkMatrix(expectedArray, sm)

    # NotAMatrix
    assert_raise(TypeError) { function.call(Object) }
  end
  
  def setup
    @m1 = SparseMatrix[[1,2,3],[4,5,6]]
	@i1 = SparseMatrix[[1,0,0],[0,1,0],[0,0,1]]
  end

  def teardown
    # do nothing
  end

  # NEED TO TEST:
#  ::[]
#  ::rows(rows, copy = true)
#  ::columns
#  ::build(row_count, #column_count, &block)
#  ::diagonal
#  ::scalar(n, value)
#  ::identity
#  ::zero
  
  def test_rows
    arr = [[0,1],[2,3]]
    creationTest(arr) { |matrixClassType| MatrixFactory.rows(matrixClassType, arr) }
  end
  
  def test_columns
    assert_equal(@m1, SparseMatrix.columns([[1,4],[2,5],[3,6]]))
  end
  
  def test_build
	assert_equal(@m1, SparseMatrix.build(2,3) {|row, col| col + 1 + (3 * row)})
  end
  
  def test_diagonal
    assert_equal(@i1, SparseMatrix.diagonal(1,1,1))
  end
  
  def test_scalar
    assert_equal(@i1, SparseMatrix.scalar(3,1))
  end
  
  def test_identity
    assert_equal(@i1, SparseMatrix.identity(3))
  end
  
  def test_zero
    assert_equal(SparseMatrix.zero(2), SparseMatrix[[0,0],[0,0]])
  end
  
end