require_relative './comm-local'

# controller for connect four
class CommFactory
  
  def initialize (commType, commSettings = nil)
    
    case commType
      when 0
        @comm = CommLocal.new commSettings
    end
    
  end

  # called after a user has completed all settings
  # returns the game model if successful 
  def startGame(players, victoryType)
    @comm.startGame(players, victoryType)
  end
  
  # sends a request to place a token
  def placeToken(col)
    @comm.placeToken(col)
  end
  
  # waits for next active state for the view
  def getNextActiveState
    @comm.getNextActiveState
  end
  
end