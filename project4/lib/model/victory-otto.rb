require_relative './victory'

# the model for OTTO Victory
class VictoryOtto < Victory
  
  def initialize
    @name = "OTTO"
    @player1VictorySequence = ['O', 'T', 'T', 'O']
    @player2VictorySequence = ['T', 'O', 'O', 'T']
    @player1Token = 'O'
    @player2Token = 'T'
  end
  
  # checks if a victory condition is met
  # board - 2D array filled with nil/player1Token/player2Token
  # returns: 0 - no victory, 1 - p1 won, 2 - p2 won, 3 p1 + p2 won
  def checkVictory (board)
    
  end
  
end

