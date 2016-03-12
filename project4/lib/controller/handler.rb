
# controller for connect four
class GameHandler
  
  #initializes handler vars
  def initialize(commType, &updateView)
    @comm
    @updateView = updateView
  end

  # called after a user has completed all settings
  # returns the game model if successful 
  def startGame (players, victoryType)
    @model = @comm.startGame players, victoryType 
    return @model
  end
  
  # called when closing the game
  def close 
    
  end
  
  #called when a player wishes to place a token
  def placeToken(col)
    @model = @comm.placeToken(col)
    updateView.call(@model)
    
    if @model.winner == 0 # No Winner, so continue
      getNextActiveState
    end
  end
  
  # called after a player's turn completes
  # if online, does not return until next player has taken turn
  # if local 2P, returns duplicate model instantly
  # if vs. com, returns (maybe with delay) the model incremented with computer move
  def getNextActiveState
    @comm.getNextActiveState
    updateView.call(@model)
  end
  
end