require 'test/unit/assertions'
require_relative '../controller/menu'

module MenuViewContract
  include Test::Unit::Assertions
  
  def class_invariant
    assert @implementation, "implementation must exist"
  end
  
  def pre_initialize(type, boardType, menuControllerType)
    assert type.class == Fixnum && type.between?(0,1), "type must be a Fixnum in range 0-1"
    assert boardType.class == Fixnum && boardType.between?(0,1), "type must be a Fixnum in range 0-1"
    assert menuControllerType.class == Symbol && [:menuControllerDefault].include?(menuControllerType), "menuControllerType must be a Symbol in [:menuControllerDefault]"
  end
  
  def post_initialize
  end

end