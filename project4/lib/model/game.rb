# the model for our game
class ConnectFourGame
  
  attr_reader :winner,
    :gameType,
    :rows,
    :cols,
    :playerTurn,
    :board
  
  # creates the board and sets the listeners
  # gameType - number: 1 = normal, 2 = OTTO
  # players - number of players
  # rows - number of rows in board
  # cols - number of cols in board
  def initialize (gameType, players = 1, rows = 6, cols = 7)
    
    @players = players
    @winner = nil # will be 0 (player 1) or 1 (player 2)
    @gameType = gameType
    @rows = rows
    @cols = cols
    
    # even = (player 1 turn), or odd = (player 2 turn)
    @playerTurn = 0
    
    # board slots are either nil (empty), 0 (player 1), or 1 (player 2)
    @board = Array.new(@rows) { Array.new(@cols) {nil} }
    
  end
  
  # col - 0 indexed from the left
  # automatically increments player turn
  def placeToken (col)
    
  end
  
  # checks for victory conditions
  def checkVictory
    
  end
  
end

