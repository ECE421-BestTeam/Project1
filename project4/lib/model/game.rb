require_relative './victory'

# the model for our game
class GameModel
  
  attr_reader :winner, # 0 = nowin, 1 = (player 1), 2 = (player 2), 3 = draw
    :victoryType,
    :rows,
    :cols,
    :turn, # even = (player 1 turn), or odd = (player 2 turn)
    :board
  
  # creates the board and sets the listeners
  # players - number of players
  # victoryType - number: 1 = normal, 2 = OTTO
  # rows - number of rows in board
  # cols - number of cols in board
  def initialize (players, victoryType, rows = 6, cols = 7)
    
    @players = players
    @winner = 0
    @victory = VictoryModel.new victoryType
    @rows = rows
    @cols = cols
    
    @turn = 0
    
    # board slots are either nil (empty), 0 (player 1), or 1 (player 2)
    @board = Array.new(@rows) { Array.new(@cols) {nil} }
    
  end
  
  # col - 0 indexed from the left
  # automatically increments player turn
  def placeToken (col)
    if @turn % 2 == 0
      #first player turn
    else
      #second player turn
    end
    
    # increment the turn
    @turn += 1
    
    @winner = checkVictory
    
    return self
  end
  
  def takeComputerTurn
    placeToken(rand(0..(@cols-1))) # do something better (col might be full)
  end
  
  # handles inbetween of human turns
  # returns updated model
  def waitForNextUpdate (currentTurn = @turn)
    # wait until model has been updated by something else
    while @turn <= currentTurn
      sleep 0 # allow other threads to do stuff
    end
    
    return self
  end
  
  # checks for victory conditions
  # returns 0 = nowin, 1 = (player 1), 2 = (player 2), 3 = draw
  def checkVictory
    returns @victory.checkVictory @board
  end
  
end