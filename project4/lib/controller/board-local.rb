require_relative '../model/board'

# local implementation of board controller
class BoardLocalController
  
  attr_reader :board, :localPlayers
  
  def initialize (settings = nil)
  end

  # called after a user has completed all settings
  # returns an array of local players if successful
  def startGame(players, victoryType)
    if players == 2
      @localPlayers = [0, 1]
    else
      @localPlayers = [0]
    end
    @board = BoardModel.new players, victoryType
  end
    
  def close
    
  end
  
  #called when a player wishes to place a token
  def placeToken (col)
    @board.placeToken (col)
  end
  
  # returns the next model where it is a local player's turn
  # if local 2P, return instantly
  # if vs. com, return after (maybe with delay) the computer's move is complete
  def getNextActiveState
    if @board.players == 1
      # let the model take the computer's turn
      @board.takeComputerTurn
    end
  end
  
end