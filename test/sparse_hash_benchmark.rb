# Our custom tests for performance
require 'test/unit'
require 'benchmark'
require 'Matrix'
require_relative '../lib/sparse_hash'

class SparseHashBM < Test::Unit::TestCase
  $min, $max = -100, 100
  attr_reader :size
  def setup
    @size = 500000
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
      x.report("sm1: ") { @size.times do |i| @sm1[i] end }
      x.report("sm2: ") { @size.times do |i| @sm2[i] end }
      x.report("ar1: ") { @size.times do |i| @ar1[i] end }
      x.report("ar2: ") { @size.times do |i| @ar2[i] end }
      x.report("h1:  ") { @size.times do |i| @h1[i] end }
      x.report("h2:  ") { @size.times do |i| @h2[i] end }
      
      puts "each"
      x.report("sm1: ") { @sm1.each do |i| i end }
      x.report("sm2: ") { @sm2.each do |i| i end }
      x.report("ar1: ") { @ar1.each do |i| i end }
      x.report("ar2: ") { @ar2.each do |i| i end }
      x.report("h1: ") { @h1.each do |i| i end }
      x.report("h2: ") { @h2.each do |i| i end }
    
      puts "each_sparse"
      x.report("sm1: ") { @sm1.each_sparse do |i| i end }
      x.report("sm2: ") { @sm2.each_sparse do |i| i end }
      x.report("ar1: ") { @ar1.each do |i| i end }
      x.report("ar2: ") { @ar2.each do |i| i end }
      x.report("h1: ") { @h1.each do |i| i end }
      x.report("h2: ") { @h2.each do |i| i end }
      
      puts "set"
      num = sparseNum
      x.report("sm1: ") { @size.times do |i| @sm1[i] = num end }
      x.report("sm2: ") { @size.times do |i| @sm2[i] = num end }
      x.report("ar1: ") { @size.times do |i| @ar1[i] = num end }
      x.report("ar2: ") { @size.times do |i| @ar2[i] = num end }
      x.report("h1:  ") { @size.times do |i| @h1[i] = num end }
      x.report("h2:  ") { @size.times do |i| @h2[i] = num end }
    end
  end
end