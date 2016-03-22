require 'test/unit/assertions'

module VictoryContract
  include Test::Unit::Assertions
  
  def class_invariant
    assert @name.class == String, "name must be a String"
    assert @playerTokens.class == Array && @playerTokens.size == 2, "playerTokens must be an Array of 2 Strings"
    assert @p1win.class == Array && @p1win.size > 0, "p1sequence must be an Array of size >1"
    assert @p2win.class == Array && @p2win.size > 0, "p2sequence must be an Array of size >1"
  end
  
  def pre_initialize(victoryType)
    assert victoryType.class == Symbol, "victoryType must be valid Symbol"
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
    assert (result.class == Symbol || result.class == NilClass) && [:draw,:player1,:player2,nil].include?(result), "result must be a valid Symbol"
  end
  
  def pre_boardEmpty(board)
    assert board.class == Array && board.size > 0 , "board must be an array (size greater than 0) of arrays (of equal sizes, greater than 0)."
  end
  
  def post_boardEmpty
  end
end
