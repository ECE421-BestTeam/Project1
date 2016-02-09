require 'test/unit'
require '../lib/sparse_hash'

class TestSparseHash < Test::Unit::TestCase
  def setup
    @s1 = SparseHash.new(4)
    @s1[0] = 0; @s1[1] = 1; @s1[2] = 0; @s1[3] = 2;
    @s2 = SparseHash.new(4)
    @s2[1] = 1; @s2[2] = 2;
  end
  
  def teardown
  end
  
  def test_get
    assert_equal(1, @s1[1])
    assert_equal(0, @s1[2])
    assert_nil(@s1[4])
    assert_nil(@s2[4])
    assert_equal(0, @s2[0])
    assert_equal(0, @s2[3])
  end

  def test_set
    @s1[1] = 4
    @s1[0] = 1
    assert_equal(4, @s1[1])
    assert_equal(1, @s1[0])
  end
  
  def test_each
    rry1 = []
    @s1.each do |x|
      rry1 << x
    end
    assert_equal([0,1,0,2], rry1)
    rry2 = []
    @s2.each do |x|
      rry2 << x
    end
    assert_equal([0,1,2,0], rry2)
  end
  
  def test_each_sparse
    rry = []
    @s2.each_sparse do |i|
      rry << @s2[i]
    end
    assert_equal([1,2], rry)
    
    h = Hash.new(4)
    @s1.each_sparse do |i|
      h[i] = @s1[i] + @s2[i]
    end
    assert_equal({1=>2,3=>2} , h)
  end
  
  def test_map
    
    assert_equal({0=>1,1=>2,2=>3,3=>1},@s2.map {|x| x+1})
  end
  
end
