require 'test/unit/assertions'

module SettingsContract
  include Test::Unit::Assertions
  
  def class_invariant
    assert @players.class == Fixnum && @players.between?(1,2), "players must be a Fixnum in 1-2"
    assert @victoryType.class == Fixnum && @victoryType.between?(0,1), "victoryType must be a Fixnum in 0-1"
    assert @boardControllerType.class == Fixnum && @boardControllerType.between?(0,1), "boardControllerType must be a Fixnum in 0-1"
    assert @rows.class == Fixnum && @rows > 0, "rows must be a Fixnum greater than 0"
    assert @cols.class == Fixnum && @cols > 0, "cols must be a Fixnum greater than 0"
  end
  
  def pre_players=(val)
    assert val.class == Fixnum && val.between?(1,2), "players must be a Fixnum in 1-2"
  end

  def pre_victoryType=(val)
    assert val.class == Fixnum && val.between?(0,1), "victoryType must be a Fixnum in 0-1"
  end
  
  def pre_boardControllerType=(val)
    assert val.class == Fixnum && val.between?(0,1), "boardControllerType must be a Fixnum in 0-1"
  end
  
  def pre_rows=(val)
    assert val.class == Fixnum && val > 0, "rows must be a Fixnum greater than 0"
  end
  
  def pre_cols=(val)
    assert val.class == Fixnum && val > 0, "cols must be a Fixnum greater than 0"
  end
  
end