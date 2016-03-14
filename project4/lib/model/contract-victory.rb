require 'test/unit/assertions'

module VictoryContract
  include Test::Unit::Assertions
  
  def class_invariant
    assert @implementation, "implementation must exist"
    assert @implementation.method(:name).arity == 0, "implementation does not have 'name' method with 0 args"
    assert @implementation.method(:playerTokens).arity == 0, "implementation does not have 'playerToken' method with 0 args"
    assert @implementation.method(:checkVictory).arity == 1, "implementation does not have 'checkVictory' method with 1 args"
  end
  
  def pre_initialize(victoryType)
    assert victoryType.class == Fixnum && victoryType.between?(0,1), "victoryType must be a Fixnum in range 0-1"
  end
  
  def post_initialize
  end

  def pre_name
  end
  
  def post_name(result)
    assert result.class == String, "result must be a string"
  end
  
  def pre_playerToken(player)
    assert player.class == Fixnum && player.between?(0,1), "player must be a Fixnum in range 0-1"
  end
  
  def post_playerToken(result)
    assert result.class == String, "result must be a string"
  end
  
  def pre_checkVictory(board)
    msg = "board must be an array (size greater than 0) of arrays (of equal sizes, greater than 0)."
    assert board.class == Array && board.size > 0, msg
    board.each do |row| 
      assert row.class == Array && row.size > 0, msg
    end
  end
  
  def post_checkVictory(result)
    assert result.class == Fixnum && result.between?(0,3), "result must be a Fixnum in range 0-3"
  end
  
end