require_relative '../../common/model/game'

# local implementation of board controller
class BoardOnlineController
  
  attr_reader :settings, :localPlayers
  
  def initialize (settings)
    @gameSettings = settings[:gameSettings]
    @clientSettings = settings[:clientSettings]
    
    # open the connection
    @connection = nil
    
    # get game
    @game = getGame
    
    # set localPlayers based on game
    @localPlayers = @game #match with @clientSettings.sesionId  or .username?
  end

  # registers the refresh command so the 
  # controller can call it when needed
  def registerRefresh(refresh)
    @refresh = refresh
    @refresh.call @game
  end
  
  # returns a GameModel
  # either starts a new game or joins an existing one
  def getGame
    # the host and port to be returned for storage
    serverAdd = {
      :host => @s.remote_address.ip_address,
      :port => @s.remote_address.ip_port
    }
    serverAdd = JSON.generate(serverAdd)
    
    @game = GameModel.new @settings
  end
    
  def close
    #close the connection
    
    return @game
  end
  
  #called when a player wishes to place a token
  def placeToken (col)
    @refresh.call @game.placeToken(col)
  end
  
  
end