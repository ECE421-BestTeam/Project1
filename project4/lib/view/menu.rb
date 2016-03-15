require_relative './contract-menu'
require_relative './menu-cmd'
require_relative './menu-gtk'

# general menu view
class MenuView
  include MenuViewContract
  
  def initialize(type, boardType = 0, menuControllerType = 0)
    pre_initialize(type, boardType, menuControllerType)

      case type
        when 0
          @implementation = MenuCmd.new boardType, menuControllerType
        when 1
          @implementation = MenuGtk.new boardType, menuControllerType
      end

      post_initialize
      class_invariant
  end
  
end