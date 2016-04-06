require_relative './contract-menu'

#require_relative '../model/client-settings'
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
    @connected = false
    
    post_initialize
    class_invariant
  end
  
  # returns a boardController initialized with a game by gameSettings
  # gameSettings should be GameSettingsModel for a new game
  # or an id String for a game, to join an existing game
  def getBoardController(gameSettings)
    pre_getBoardController(gameSettings)
    
    controllerSettings = {
      :gameSettings => gameSettings,
      :clientSettings => @clientSettings
    }
    
    result = nil
    case gameSettings.mode
      when :practice
        result = BoardController.new(:boardControllerLocal, controllerSettings)
      when :compete
        result = BoardController.new(:boardControllerOnline, controllerSettings)
    end

    post_getBoardController(result)
    class_invariant
    return result
  end
  
  # attempts to connect to the current server
  # return true/false on success/failure
  def connectToServer
    closeServerConnection
    @clientSettings.serverAddress
  end
  
  def closeServerConnection
    @connection.close
  end
  
  # on success will set the sessionID
  def createPlayer(username, password)
#    @clientSettings.sessionId = 
  end
  
  # on success will set the sessionID
  def login(username, password)
#    @clientSettings.sessionId = 
  end
  
  def logout
    
  end
  
end