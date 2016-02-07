# Our custom tests for performance
require 'test/unit'
require 'benchmark'
require 'Matrix'
require_relative '../lib/sparse_matrix'

class SparseOpsTest < Test::Unit::TestCase
  $min, $max = -100, 100
  def setup
    size = 100
    ar1 = Array.new(size) { Array.new(size) {sparseNum()} }
    ar2 = Array.new(size) { Array.new(size) {sparseNum()} }
    @sm1 = SparseMatrix.rows(ar1)
    @sm2 = SparseMatrix.rows(ar2)
    @dm1 = Matrix.rows(ar1)
    @dm2 = Matrix.rows(ar2)
  end
  
  def teardown
  end
  
  def sparseNum
    if (rand(0..4) % 3 == 1)
      
      return rand($min..$max)
    else
      return 	0
    end
  end
  
  def test_addition
    Benchmark.bm do |x|
      x.report("sparse: ") { @sm1 + @sm2 }
      x.report("dense:  ") { @dm1 + @dm2 }
    end
  end
end
