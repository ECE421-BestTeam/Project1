require_relative './board-local'

# board controller interface
class BoardController
  
  #initializes the selected board controller
  def initialize (type, settings = nil)
    
    case type
      when 0
        @implementation = BoardLocalController.new settings
    else
      raise ArgumentError "invalid board controller type, #{type}, can be: 0" 
    end
    
  end

  def game
    @implementation.game
  end
  
  def localPlayers
    @implementation.localPlayers
  end
  
  # called after a user has completed all settings
  # returns an array of local players if successful
  def startGame(players, victoryType)
    @implementation.startGame(players, victoryType)
  end
  
  # called when closing the game
  def close 
    @implementation.close
  end
    
  # sends a request to place a token
  def placeToken(col)
    @implementation.placeToken(col)
  end
  
  # returns the next model where it is a local player's turn
  def getNextActiveState
    @implementation.getNextActiveState
  end
  
end