# the model for normal Victory
class VictoryNormal
  
  attr_reader :name, :playerTokens
  
  def initialize
    @name = "Normal"
    @playerTokens = ['O', 'X']
    @player1VictorySequence = [
      @playerTokens[0],
      @playerTokens[0],
      @playerTokens[0],
      @playerTokens[0]
      ]
    @player2VictorySequence = [
      @playerTokens[1],
      @playerTokens[1],
      @playerTokens[1],
      @playerTokens[1]
      ]
  end
  
  # checks if a victory condition is met
  # board - 2D array filled with nil/player1Token/player2Token
  # returns: 0 - no victory, 1 - p1 won, 2 - p2 won, 3 p1 + p2 won
  def checkVictory (board)
    # p1 victory
    
    # p2 victory
    
  end
  
end

