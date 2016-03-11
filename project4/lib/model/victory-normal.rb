require_relative './victory'


# the model for normal Victory
class VictoryNormal < Victory
  
  def initialize
    @name = "Normal"
    @player1VictorySequence = ['0', '0', '0', '0']
    @player2VictorySequence = ['1', '1', '1', '1']
    @player1Token = '0'
    @player2Token = '1'
  end
  
  # checks if a victory condition is met
  # board - 2D array filled with nil/player1Token/player2Token
  # returns: 0 - no victory, 1 - p1 won, 2 - p2 won, 3 p1 + p2 won
  def checkVictory (board)
    
  end
  
end

