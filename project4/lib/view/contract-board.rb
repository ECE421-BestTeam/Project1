require 'test/unit/assertions'
require_relative '../controller/board'

module BoardViewContract
  include Test::Unit::Assertions
  
  def class_invariant
    assert @implementation, "implementation must exist"
  end
  
  def pre_initialize(type, controller, game, exitCallback)
    assert type.class == Fixnum && type.between?(0,1), "type must be a Fixnum in range 0-1"
    assert controller.class == BoardController, "controller must be a BoardController"
    assert game.class == GameModel, "game must be of class GameModel"
    if exitCallback
      assert exitCallback.class == Proc && exitCallback.arity == 1, "exitCallback must be a Proc that accepts 1 argument"
    end
  end
  
  def post_initialize
  end

end