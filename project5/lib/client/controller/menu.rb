require_relative './contract-menu'

#require_relative '../model/client-settings'
require_relative './online-helper'
require_relative './board-local'
require_relative './board-online'

# menu/settings controller interface
class MenuController
  include MenuControllerContract
  include OnlineHelper
  
  attr_accessor :clientSettings
  
  #initializes the menu controller
  def initialize(clientSettings = ClientSettingsModel.new)
    pre_initialize(clientSettings)
    
    @clientSettings = clientSettings
    @connected = false
    
    post_initialize
    class_invariant
  end
  
  def close
    
  end
  
  # returns a boardController initialized with a game by gameSettings
  # gameSettings should be GameSettingsModel for a new game
  # or an id String for a game, to join an existing game
  def getBoardController(type, gameSettings)
    pre_getBoardController(type, gameSettings)
    
    controllerSettings = {
      :gameSettings => gameSettings,
      :clientSettings => @clientSettings
    }
    
    result = nil
#    case type
#      when 'local'
#        result = BoardController.new(:boardControllerLocal, controllerSettings)
#      when 'online'
#        result = BoardController.new(:boardControllerOnline, controllerSettings)
#    end
    case type
      when 'local'
        result = BoardLocalController.new controllerSettings
      when 'online'
        result = BoardOnlineController.new controllerSettings
    end

    post_getBoardController(result)
    class_invariant
    return result
  end
  
  
  # on success will set the sessionID
  def createAccount(username, password)
    handleResponse(Proc.new {
        @connection.call('createPlayer', username, password)
      },
      Proc.new do |data|
        @clientSettings.sessionId = data
        @clientSettings.username = username
      end
    )
  end
  
  # on success will set the sessionID
  def login(username, password)
    handleResponse(Proc.new {
        @connection.call('login', username, password)
      },
      Proc.new do |data|
        @clientSettings.sessionId = data
        @clientSettings.username = username
      end
    )
  end
  
  # on success no exceptions are thrown
  def logout
    handleResponse(Proc.new {
        @connection.call('logout', @clientSettings.sessionId, @clientSettings.username)
      },
      Proc.new do |data|
        if data 
          @clientSettings.sessionId = ''
          @clientSettings.username = ''
        end
      end
    )
  end
  
  # returns a hash of arrays 
  # keys = active/saved/joinable
  # arrays contain gameIds
  def getGames
    result = {}
    handleResponse(Proc.new {
        @connection.call('getGames', @clientSettings.sessionId)
      },
      Proc.new do |data|
        result = data
      end
    )
    return result
  end
  
  # returns the stats for the current player
  def getMyStatistics
    result = {}
    handleResponse(Proc.new {
        @connection.call('getMyStatistics', @clientSettings.sessionId)
      },
      Proc.new do |data|
        result = data
      end
    )
    return result
  end
  
  # returns the top statistics for everyone
  def getTopStatistics
    result = {}
    handleResponse(Proc.new {
        @connection.call('getTopStatistics')
      },
      Proc.new do |data|
        result = data
      end
    )
    return result
  end
  
end