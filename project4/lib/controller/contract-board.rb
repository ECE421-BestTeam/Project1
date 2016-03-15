require 'test/unit/assertions'
require_relative '../model/game'
require_relative '../model/settings'

module BoardControllerContract
  include Test::Unit::Assertions
  
  def class_invariant
    assert @implementation, "implementation must exist"
    methods = [
      { :name => :settings, :args => 0 },
      { :name => :localPlayers, :args => 0 },
      { :name => :startGame, :args => 0 },
      { :name => :close, :args => 0 },
      { :name => :placeToken, :args => 1 },
      { :name => :getNextActiveState, :args => 0 }
    ]
    methods.each do |method|
      assert @implementation.method(method[:name]).arity == method[:args], "implementation does not have '#{method[:name]}' method with #{method[:args]} args"
    end
  end
  
  def pre_initialize(type, settings)
    assert type.class == Fixnum && type.between?(0,0), "type must be a Fixnum in range 0-0"
    assert settings.class == SettingsModel, "settings must be a SettingsModel"
  end
  
  def post_initialize
  end

  def pre_settings
  end
  
  def post_settings(result)
    assert result.class == SettingsModel, " must be of class SettingsModel"
  end
  
  def pre_localPlayers
  end
  
  def post_localPlayers(result)
    assert result.class == Array, "result must be an Array"
  end
  
  def pre_startGame
  end
  
  def post_startGame(result)
    assert result.class == GameModel, "result must be of class GameModel"
  end
  
  def pre_close
  end
  
  def post_close
  end
  
  def pre_placeToken(col)
    assert col.class == Fixnum && col.between?(0, game.cols - 1), "col must be a Fixnum in range 0-#{game.cols - 1}"
  end
  
  def post_placeToken(result)
    assert result.class == GameModel, "result must be of class GameModel"
  end
  
  def pre_getNextActiveState
  end
  
  def post_getNextActiveState(result)
    assert result.class == GameModel, "result must be of class GameModel"
  end
  
end