require 'test/unit/assertions'

module GameSettingsContract
  include Test::Unit::Assertions
  
  def class_invariant
    assert @players.class == Fixnum && @players.between?(1,2), "players must be a Fixnum in 1-2"
    assert @victoryType.class == Symbol && [:victoryNormal, :victoryOtto].include?(@victoryType), "victoryType must be a Symbol in [:victoryNormal, :victoryOtto]"
    assert @mode.class == Symbol && [:practice, :compete].include?(@mode), "mode must be a Symbol in [:practice, :compete]"
    assert @rows.class == Fixnum && @rows > 0, "rows must be a Fixnum greater than 0"
    assert @cols.class == Fixnum && @cols > 0, "cols must be a Fixnum greater than 0"
  end
  
  def pre_players=(val)
    assert val.class == Fixnum && val.between?(1,2), "players must be a Fixnum in 1-2"
  end

  def pre_victoryType=(val)
    assert val.class == Symbol && [:victoryNormal, :victoryOtto].include?(val), "victoryType must be a Symbol in [:victoryNormal, :victoryOtto]"
  end
  
  def pre_boardControllerType=(val)
    assert val.class == Symbol && [:practice, :compete].include?(val), "mode must be a Symbol in [:practice, :compete]"
  end
  
  def pre_rows=(val)
    assert val.class == Fixnum && val > 0, "rows must be a Fixnum greater than 0"
  end
  
  def pre_cols=(val)
    assert val.class == Fixnum && val > 0, "cols must be a Fixnum greater than 0"
  end
  
end