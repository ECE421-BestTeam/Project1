# Our custom tests for performance
require 'test/unit'
require 'benchmark'
require 'Matrix'
require_relative '../lib/sparse_matrix'

class SparseOpsTest < Test::Unit::TestCase
  $min, $max = -100, 100
  attr_reader :size
  def setup
    @size = 500
    ar1 = Array.new(size) { Array.new(size) {sparseNum()} }
    ar2 = Array.new(size) { Array.new(size) {sparseNum()} }
    
    @sm1 = SparseMatrix.rows(ar1)
    @sm2 = SparseMatrix.rows(ar2)
    @dm1 = Matrix.rows(ar1)
    @dm2 = Matrix.rows(ar2)
    
    @sm3 = SparseMatrix[[1,0],[0,1]]
    @sm4 = SparseMatrix[[0,2],[1,2]]
    @m3 = Matrix[[1,0],[0,1]]
    @m4 = Matrix[[0,2],[1,2]]
  end
  
  def teardown
  end
  
  def sparseNum
    if (rand(0..10) == 1)
      
      return rand($min..$max)
    else
      return 	0
    end
  end
  
  def test_add_bm
    puts
    Benchmark.bm do |x|
      x.report("sparse: ") { @sm1 + @sm2 }
      x.report("dense:  ") { @dm1 + @dm2 }
    end
  end
  
    def test_sub_bm
    puts
    Benchmark.bm do |x|
      x.report("sparse: ") { @sm1 - @sm2 }
      x.report("dense:  ") { @dm1 - @dm2 }
    end
  end

  def test_add
    idx = rand(0...size)
    ss= @sm1 + @sm2
    dd= @dm1 + @dm2

    assert_equal(dd[idx,idx], ss[idx,idx])
  end
  
  def test_sub
   idx = rand(0...size)
    ss= @sm1 - @sm2
    dd= @dm1 - @dm2
    puts "#{idx},#{idx}, #{size}"
    assert_equal(dd[idx,idx], ss[idx,idx])
  end
end
