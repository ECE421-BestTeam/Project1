require 'test/unit'
require '../lib/sparse2Dhash'

class TestSparse2DHash < Test::Unit::TestCase
  def setup
    @s1 = Sparse2DHash.new(3,4)
    @s1[0,0] = 0; @s1[0,1] = 1; @s1[0,2] = 0; @s1[0,3] = 0;
    @s1[1,0] = 1; @s1[1,1] = 2; @s1[1,2] = 0; @s1[1,3] = 1;
    @s1[2,0] = 3; @s1[2,1] = 1; @s1[2,2] = 0; @s1[2,3] = 1;
    @s2 = Sparse2DHash.new(3,4)
    @s2[1,1] = 1; @s2[1,2] = 2;
    @s2[2,1] = 3; @s2[2,2] = 0;
    
  end
  
  def teardown
  end
  
  def test_get
    assert_equal(0, @s1.get(1,2))
    assert_equal(0, @s1.get(0,0))
    assert_nil(@s1.get(3,4))
    assert_nil(@s1.get(0,4))
    assert_equal(2, @s1.get(1,1))
  end
  
  def test_getrow
    s1 = @s1.get_row(0)
    assert_equal(s1[0],0)
    assert_equal(s1[1],1)

    s2 = @s2.get_row(2)
    assert_equal(s2[0],0)
    assert_equal(s2[1],3)
    assert_nil(@s1.get_row(3))
    
  end
  
  def test_set
    @s1[1,0] = 4
    @s1[2,1] = 4
    assert_equal(4, @s1[1,0])
    assert_equal(4, @s1[2,1])
  end
  
  def test_each
    puts "\ns1\n"
    @s1.each do |x|
      print x, " "
    end
    puts "\ns2\n"
    @s2.each do |x|
      print x, " "
    end
  end
  
  def test_each_sparse
    puts
    @s1.each_sparse do |x|
      print x, " \n"
    end
  end
  
  def test_each_with_index_sparse
    puts
    @s1.each_with_index_sparse do |i, x|
      print i, ":",x, " \n"
    end
  end
  
  
end
    