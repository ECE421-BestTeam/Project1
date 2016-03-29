require_relative '../../common/model/game'

# local implementation of board controller
class BoardLocalController
  
  attr_reader :settings, :localPlayers
  
  def initialize (settings)
    @settings = settings
    if @settings.players == 2
      @localPlayers = [0, 1]
    else
      @localPlayers = [0]
    end
  end

  # returns a new GameModel
  def startGame
    @game = GameModel.new @settings
  end
    
  def close
    return @game
  end
  
  #called when a player wishes to place a token
  def placeToken (col)
    @game.placeToken (col)
  end
  
  # returns the next model where it is a local player's turn
  # if local 2P, return instantly
  # if vs. com, return after (maybe with delay) the computer's move is complete
  def getNextActiveState
    if @settings.players == 1
      # let the model take the computer's turn
      @game.computerTurn
    end
    return @game
  end
  
end