require_relative './contract-board'
require_relative './board-cmd'
require_relative './board-gtk'

# general board view
class BoardView
  include BoardViewContract
  
  def initialize(type, controller, &exitCallback)
    pre_initialize(type, controller, exitCallback)

      case type
        when :boardCmd
          @implementation = BoardCmd.new controller, exitCallback
        when :boardGtk
          @implementation = BoardGtk.new controller, exitCallback
      end

      post_initialize
      class_invariant
  end
  
end