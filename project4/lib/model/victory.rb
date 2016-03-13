require_relative './victory-normal'
require_relative './victory-otto'

# produces the desired victory object
class VictoryModel
  
  # victoryType - number: 1 = normal, 2 = OTTO
  def initialize (victoryType)
    
    case victoryType
      when 1
        @implementation = VictoryNormal.new
      when 2
        @implementation = VictoryOtto.new
    end
    
  end
  
  def name
    @implementation.name
  end
  
  def playerToken(player)
    @implementation.playerTokens[player]
  end
  
  # checks if a victory condition is met
  # board - 2D array filled with nil/player1Token/player2Token
  # returns: 0 - no victory, 1 - p1 won, 2 - p2 won, 3 p1 + p2 won
  def checkVictory (board)
    @implementation.checkVictory(board)
  end
  
end

