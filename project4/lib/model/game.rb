require_relative './victory'

# the model for our game
class GameModel
  
  attr_reader :settings,
    :winner, # 0 = nowin, 1 = (player 1), 2 = (player 2), 3 = draw
    :turn, # even = (player 1 turn), or odd = (player 2 turn)
    :board
  
  # creates the board and sets the listeners
  # settings a SettingsModel object
  def initialize (settings)
    
    @settings = settings
    @winner = 0
    @victory = VictoryModel.new @settings.victoryType
    @turn = 0
    
    # board slots are either nil (empty), 0 (player 1), or 1 (player 2)
    @board = Array.new(@settings.rows) { Array.new(@settings.cols) {nil} }
    
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
    placeToken(rand(0..(@settings.cols-1))) # do something better (col might be full)
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