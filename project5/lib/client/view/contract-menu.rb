require 'test/unit/assertions'
require_relative '../controller/menu'

module MenuViewContract
  include Test::Unit::Assertions
  
  def class_invariant
    assert @implementation, "implementation must exist"
  end
  
  def pre_initialize(type, boardType, menuControllerType)
    assert type.class == Symbol && [:menuCmd, :menuGtk].include?(type), "MenuView type must be a Symbol in [:menuCmd, :menuGtk]"
    assert boardType.class == Symbol && [:boardCmd, :boardGtk].include?(boardType), "BoardView type must be a Symbol in [:boardCmd, :boardGtk]"
    assert menuControllerType.class == Symbol && [:menuControllerDefault].include?(menuControllerType), "menuControllerType must be a Symbol in [:menuControllerDefault]"
  end
  
  def post_initialize
  end

end