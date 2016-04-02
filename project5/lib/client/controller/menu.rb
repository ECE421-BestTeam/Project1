require_relative './contract-menu'
require_relative './board'

# menu/settings controller interface
class MenuController
  include MenuControllerContract
  
  attr_accessor :settings
  
  #initializes the menu controller
  def initialize(settings = SettingsModel.new)
    pre_initialize(settings)
    
    @settings = settings
    
    post_initialize
    class_invariant
  end
  
  # called after a user has completed all settings
  # returns GameModel successful
  def getBoardController
    pre_getBoardController
    
    result = BoardController.new(@settings)

    post_getBoardController(result)
    class_invariant
    return result
  end
  
end