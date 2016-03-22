require 'test/unit/assertions'
require_relative '../controller/board'

module BoardViewContract
  include Test::Unit::Assertions
  
  def class_invariant
    assert @implementation, "implementation must exist"
  end
  
  def pre_initialize(type, controller, exitCallback)
    assert type.class == Symbol && [:boardCmd, :boardGtk].include?(type), "BoardView type must be a Symbol in [:boardCmd, :boardGtk]"
    assert controller.class == BoardController, "controller must be a BoardController"
    if exitCallback
      assert exitCallback.class == Proc && exitCallback.arity == 1, "exitCallback must be a Proc that accepts 1 argument"
    end
  end
  
  def post_initialize
  end

end