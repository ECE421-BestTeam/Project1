require 'test/unit/assertions'
require_relative '../../controller/board'

module CmdBoardViewContract
  include Test::Unit::Assertions
  
  def pre_initialize(controller, exitCallback)
    assert controller.class == BoardController, "controller must be a BoardController"
    if exitCallback
      assert exitCallback.class == Proc && exitCallback.arity == 1, "exitCallback must be a Proc that accepts 1 argument"
    end
  end
  
  def post_initialize
  end

end