# the interface for victory types
class Victory
  
  attr_reader :name,
    :player1Token, # should be 1 character
    :player2Token # should be 1 character

  def initialize 
    raise NotImplementedError, "Implement this method in a child class"
  end
  
  # checks if a victory condition is met
  # board - 2D array filled with nil/player1Token/player2Token
  # returns: 0 - no victory, 1 - p1 won, 2 - p2 won, 3 p1 + p2 won
  def checkVictory (board)
    raise NotImplementedError, "Implement this method in a child class"
  end
  
end

