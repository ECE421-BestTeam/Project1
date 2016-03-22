require 'test/unit/assertions'

require_relative './board'
require_relative '../model/settings'

module MenuControllerContract
  include Test::Unit::Assertions
  
  def class_invariant
    assert @implementation, "implementation must exist"
    methods = [
      { :name => :players, :args => 0 },
      { :name => :players=, :args => 1 },
      { :name => :victoryType, :args => 0 },
      { :name => :victoryType=, :args => 1 },
      { :name => :boardControllerType, :args => 0 },
      { :name => :boardControllerType=, :args => 1 },
      { :name => :rows, :args => 0 },
      { :name => :rows=, :args => 1 },
      { :name => :cols, :args => 0 },
      { :name => :cols=, :args => 1 }
    ]
    methods.each do |method|
      assert @implementation.method(method[:name]).arity == method[:args], "implementation does not have '#{method[:name]}' method with #{method[:args]} args"
    end
  end
  
  def pre_initialize(type)
    assert type.class == Symbol && [:menuControllerDefault].include?(type), "menuController type must be a Symbol in [:menuControllerDefault]"
  end

  def post_initialize
  end
  
  def pre_getBoardController
  end
  
  def post_getBoardController(result)
    assert result.class == BoardController, "boardController type must be a BoardController"
  end
  
  def pre_settings
  end
  
  def post_settings(result)
    assert result.class == SettingsModel, "settings type must be a SettingsModel"
  end
  
  def pre_players=(val)
    assert val.class == Fixnum && val.between?(1,2), "players must be a Fixnum in 1-2"
  end

  def pre_victoryType=(val)
    assert val.class == Symbol && [:victoryNormal, :victoryOtto].include?(val), "victoryType must be a Symbol in [:victoryNormal, :victoryOtto]"
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