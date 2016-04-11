require_relative '../../common/model/game'

# local implementation of board controller
class BoardLocalController
  
  attr_reader :settings, :localPlayers
  
  def initialize (settings)
    
    @settings = settings[:gameSettings]
    if @settings.players == 2
      @localPlayers = [1, 2]
    else
      @localPlayers = [1]
    end
    @game = GameModel.new @settings
  end

  # registers the refresh command so the 
  # controller can call it when needed
  def registerRefresh(refresh)
    @refresh = refresh
    @refresh.call({'type' => 'game', 'data' => @game})
  end
    
  def close
    return @game
  end
  
  #called when a player wishes to place a token
  def placeToken (col)
    @refresh.call({'type' => 'game', 'data' => @game.placeToken(col)})
    if @settings.players == 1
      # let the model take the computer's turn
      @refresh.call({'type' => 'game', 'data' => @game.computerTurn})
    end
  end
  
  def sendSaveRequest
    raise ArgumentError, "saveRequest not supported in practice mode."
  end
  
  def sendSaveResponse(response)
    raise ArgumentError, "saveRequest not supported in practice mode."
  end
  
  def sendForfeit
    raise ArgumentError, "forfeit not supported in practice mode."
  end
  
end