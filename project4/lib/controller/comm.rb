# controller for connect four
class CommHandler
  
  def initialize
    raise NotImplementedError, "Implement this method in a child class"
  end

  # called after a user has completed all settings
  # returns the game model if successful 
  def startGame (players, victoryType)
    @game = ConnectFourGame.new players, victoryType
  end
  
  # sends a request to place a token
  def placeToken
    raise NotImplementedError, "Implement this method in a child class"
  end
  
  # waits for next active state for the view
  def getNextActiveState
    raise NotImplementedError, "Implement this method in a child class"
  end
  
end