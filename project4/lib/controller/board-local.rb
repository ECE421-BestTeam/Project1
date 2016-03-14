require_relative '../model/game'

# local implementation of board controller
class BoardLocalController
  
  attr_reader :game, :localPlayers
  
  def initialize (settings = nil)
  end

  # called after a user has completed all settings
  # returns GameModel successful
  def startGame(players, victoryType)
    if players == 2
      @localPlayers = [0, 1]
    else
      @localPlayers = [0]
    end
    @game = GameModel.new players, victoryType
  end
    
  def close
    
  end
  
  #called when a player wishes to place a token
  def placeToken (col)
    @game.placeToken (col)
  end
  
  # returns the next model where it is a local player's turn
  # if local 2P, return instantly
  # if vs. com, return after (maybe with delay) the computer's move is complete
  def getNextActiveState
    if @game.players == 1
      # let the model take the computer's turn
      @game.takeComputerTurn
    end
  end
  
end