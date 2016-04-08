require 'test/unit/assertions'

module CmdBoardViewContract
  include Test::Unit::Assertions
  
  def pre_initialize(controller, exitCallback)
    assert controller != nil, "boardController exist"
    if exitCallback
      assert exitCallback.class == Proc && exitCallback.arity == 1, "exitCallback must be a Proc that accepts 1 argument"
    end
  end
  
  def post_initialize
  end

end