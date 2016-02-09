# Our custom tests for performance
require 'test/unit'
require 'benchmark'
require 'Matrix'
require_relative '../lib/sparse-hash'

class SparseHashBM < Test::Unit::TestCase
  $min, $max = -100, 100
  attr_reader :size
  def setup
    @size = 50000
    @ar1 = Array.new(size) { sparseNum() }
    @ar2 = Array.new(size) { sparseNum() }
    @sm1 = SparseHash.new(size)
    @sm2 = SparseHash.new(size)
    @h1 = Hash.new(size)
    @h2 = Hash.new(size)
    size.times do |x|
      @sm1[x] = @ar1[x]
      @sm2[x] = @ar2[x]
      @h1[x] = @ar1[x]
      @h2[x] = @ar2[x]
    end
    
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
  
  def test_get
    puts
    Benchmark.bm do |x|
      puts "get"
      idx = size
      x.report("sm1: ") { @sm1[idx] }
      x.report("sm2: ") { @sm2[idx] }
      x.report("ar1: ") { @ar1[idx] }
      x.report("ar2: ") { @ar2[idx] }
      x.report("h1:  ") { @h1[idx]  }
      x.report("h2:  ") { @h2[idx]  }
      
      puts "each"
      x.report("sm1: ") { @sm1.each do |i| i end }
      x.report("sm2: ") { @sm2.each do |i| i end }
      x.report("ar1: ") { @ar1.each do |i| i end }
      x.report("ar2: ") { @ar2.each do |i| i end }
      x.report("h1:  ") { @h1.each do |i| i end }
      x.report("h2:  ") { @h2.each do |i| i end }
    
      puts "each_sparse"
      x.report("sm1: ") { @sm1.each_sparse do |i| i end }
      x.report("sm2: ") { @sm2.each_sparse do |i| i end }
      x.report("ar1: ") { @ar1.each do |i| i end }
      x.report("ar2: ") { @ar2.each do |i| i end }
      x.report("h1:  ") { @h1.each do |i| i end }
      x.report("h2:  ") { @h2.each do |i| i end }
      
      puts "set"
      num = sparseNum
      
      x.report("sm1: ") { @sm1[idx] = num }
      x.report("sm2: ") { @sm2[idx] = num }
      x.report("ar1: ") { @ar1[idx] = num }
      x.report("ar2: ") { @ar2[idx] = num }
      x.report("h1:  ") { @h1[idx] = num }
      x.report("h2:  ") { @h2[idx] = num}
    end
  end
end