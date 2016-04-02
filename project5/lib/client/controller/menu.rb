require_relative './contract-menu'

require_relative './board-local'
require_relative './board-online'

# menu/settings controller interface
class MenuController
  include MenuControllerContract
  
  attr_accessor :clientSettings
  
  #initializes the menu controller
  def initialize(clientSettings = ClientSettingsModel.new)
    pre_initialize(clientSettings)
    
    @clientSettings = clientSettings
    
    post_initialize
    class_invariant
  end
  
  # called after a user has completed all settings
  # returns GameModel successful
  def getBoardController(settings)
    pre_getBoardController(settings)
    
    controllerSettings = {
      :gameSettings => settings,
      :clientSettings => @clientSettings
    }
    
    result = nil
    case settings.mode
      when :practice
        result = BoardController.new(:boardControllerLocal, controllerSettings)
      when :compete
        result = BoardController.new(:boardControllerOnline, controllerSettings)
    end

    post_getBoardController(result)
    class_invariant
    return result
  end
  
end