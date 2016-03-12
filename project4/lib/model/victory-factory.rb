require_relative './victory-normal'
require_relative './victory-otto'


# produces the desired victory object
class VictoryFacotry
  
  # victoryType - number: 1 = normal, 2 = OTTO
  def initialize (victoryType)
    
    case victoryType
      when 1
        @vic = VictoryNormal.new
      when 2
        @vic = VictoryOtto.new
    end
    
  end
  
  # checks if a victory condition is met
  # board - 2D array filled with nil/player1Token/player2Token
  # returns: 0 - no victory, 1 - p1 won, 2 - p2 won, 3 p1 + p2 won
  def checkVictory (board)
    @vic.checkVictory(board)
  end
  
end

