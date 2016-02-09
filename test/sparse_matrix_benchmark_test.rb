# Our custom tests for performance
require 'test/unit'
require 'benchmark'
require 'Matrix'
require '../lib/sparse_matrix'

class SparseMatrixTest < Test::Unit::TestCase
  
  $min, $max = -100, 100

  def sparseNum (ourRand, sparsity)
    a = ourRand.rand(0..sparsity)
    if (a == 0) #43 is great
      return ourRand.rand($min..$max)
    else
      return 	0
    end
  end
  
	def createRandomSparseMatrices(size, sparsity)    
    random = Random.new(1234)
    ar1 = Array.new(size) { Array.new(size) {sparseNum(random, sparsity)} }
    ar2 = Array.new(size) { Array.new(size) {sparseNum(random, sparsity)} }
    dm1 = Matrix.rows(ar1)
		dm2 = Matrix.rows(ar2)
    sm1 = SparseMatrix.rows(ar1)
    sm2 = SparseMatrix.rows(ar2)
    return [dm1, dm2, sm1, sm2]
  end

  def teardown
    # do nothing
	end

  def doBenchmarkTest(name, size, runs, sparsity = 35, &function)
    if (size.class == Array)
      m = size
    else 
      m = createRandomSparseMatrices(size, sparsity)
    end
    dm1, dm2, sm1, sm2 = m[0], m[1], m[2], m[3]
    bmd, bms = 0, 0
    Benchmark.bm do |x|
      bmd += (x.report(name + " dense: ") {(0..runs).each {function.call(dm1, dm2)} }).total
      bms += (x.report(name + " sparse: ") { (0..runs).each {function.call(sm1, sm2)} }).total
    end
    assert_operator bms, :<=, bmd * 1.1 #apply a constant because the sparse may be faster programmatically but the computer may have just been slwer for it's runs
  end
  
#	def test_addition
#    doBenchmarkTest("addition", 1900, 3) {|m1, m2| m1 + m2}
#  end
#  
#  def test_determinant  
#    doBenchmarkTest("determinant", 135, 3, 43) {|m1, m2| m1.determinant()}
#  end
#  
#  def test_inverse
#    doBenchmarkTest("inverse", 45, 2, 8) {|m1, m2| m1.inverse()}
#  end
  
  def test_multiplication
    doBenchmarkTest("multiplication", 100, 3, 10) {|m1, m2| m1 * m2}
  end
#  
#  def test_subtraction
#    doBenchmarkTest("subtraction", 1900, 3) {|m1, m2| m1 - m2}
#  end
#  
#  def test_transpose
#    doBenchmarkTest("transpose", 3500, 3) {|m1, m2| m1.transpose()}
#  end
#  
#  def test_zero
#    # Zero arrays
#    size = 1000
#    arr = Array.new(size) { Array.new(size) {0} }
#    dm = Matrix.rows(arr);
#    sm = SparseMatrix.rows(arr);
#    doBenchmarkTest("zero true", [dm, dm, sm, sm], 3) {|m1| m1.zero? }
#  end
  
end