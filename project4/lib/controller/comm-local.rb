require_relative '../model/game'
require_relative './comm'

# controller for connect four
class LocalComm < Comm
  
  def initialize
  end

  def startGame
    super
  end
    
  def placeToken (col)
    return @game.placeToken (col)
  end
  
  # if local 2P, returns duplicate model instantly
  # if vs. com, returns (maybe with delay) the model incremented with computer move
  def getNextActiveState
    if @game.players == 1
      # let the model take the computer's turn
      return @game.waitForNextUpdate
    else
      # return control to the game for 2nd player
      return @game
    end
  end
  
end