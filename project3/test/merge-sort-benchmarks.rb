require 'test/unit'
require'../lib/merge-sort'
require 'benchmark'

class MergeSortTest < Test::Unit::TestCase
  include MergeSort
  
  def setup
    @a100 = Array.new(100) { rand(100) }
    @a1000 = Array.new(1000) { rand(1000) }
    @a10000 = Array.new(10000) { rand(10000) }
    @a100000 = Array.new(100000) { rand(100000) }
    @timeout = 0
    @comparator ||= ->(a,b) { a <=> b }

  end
  
  def teardown
  end
  
  def test_benchmarks
    
      Benchmark.bm  do |x|
        x.report("100  builtin:") {
          @a100.sort
        }
        x.report("100   pmerge:") {
          sort(@a100, @timeout, &@comparator)
        }
      end
      
      Benchmark.bm  do |x|
        x.report("1000  builtin:") {
          @a1000.sort
        }
        x.report("1000   pmerge:") {
          sort(@a1000, @timeout, &@comparator)
        }
      end
      
      Benchmark.bm  do |x|
        x.report("10000 builtin:") {
          @a10000.sort
        }
        x.report("10000  pmerge:") {
          sort(@a10000, @timeout, &@comparator)
        }
      end

  end
  
  def test_benchmarks_with_timeout
  
  end
end
  
  