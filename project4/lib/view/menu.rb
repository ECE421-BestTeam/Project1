require_relative './contract-menu'
require_relative './menu-cmd'
require_relative './menu-gtk'

# general menu view
class MenuView
  include MenuViewContract
  
  def initialize(type, boardType = :boardCmd, menuControllerType = :menuControllerDefault)
    pre_initialize(type, boardType, menuControllerType)

      case type
        when :menuCmd
          @implementation = MenuCmd.new boardType, menuControllerType
        when :menuGtk
          @implementation = MenuGtk.new boardType, menuControllerType
      end

      post_initialize
      class_invariant
  end
  
end