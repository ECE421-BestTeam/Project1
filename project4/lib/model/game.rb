require_relative './contract-game'
require_relative './victory'

# the model for our game
class GameModel
  include GameContract
  
  attr_reader :settings,
    :winner, # 0 = nowin, 1 = (player 1), 2 = (player 2), 3 = draw
    :turn, # even = (player 1 turn), or odd = (player 2 turn)
    :board
  
  # creates the board and sets the listeners
  # settings a SettingsModel object
  def initialize (settings)
    pre_initialize(settings)
    
    @settings = settings
    @winner = 0
    @victory = VictoryModel.new @settings.victoryType
    @turn = 0
    
    # board slots are either nil (empty), 0 (player 1), or 1 (player 2)
    @board = Array.new(@settings.rows) { Array.new(@settings.cols) {nil} }
    
    post_initialize
    class_invariant
  end
  
  # col - 0 indexed from the left
  # automatically increments player turn
  def placeToken (col)
    pre_placeToken(col)
    
    if @turn % 2 == 0
      #first player turn
    else
      #second player turn
    end
    
    # increment the turn
    @turn += 1
    
#    checkVictory
    
    result = self
    
    post_placeToken(result)
    class_invariant
    return result
  end
  
  def computerTurn
    pre_computerTurn
    
    placeToken(rand(0..(@settings.cols-1))) # do something better (col might be full)
    result = self
    
    post_computerTurn(result)
    class_invariant
    return result
  end
  
  # handles inbetween of human turns
  # returns updated model
  def waitForNextUpdate (currentTurn = @turn)
    pre_waitForNextUpdate(currentTurn)
    
    # wait until model has been updated by something else
    while @turn <= currentTurn
      sleep 0 # allow other threads to do stuff
    end
    result = self
    
    post_waitForNextUpdate(result)
    class_invariant
    return result
  end
  
  # checks for victory conditions
  # returns false - no winner, true - winner exists
  def checkVictory
    pre_checkVictory
    
    if @winner == 0  
      @winner = @victory.checkVictory @board
    end
    result = @winner
    
    post_checkVictory(result)
    class_invariant
    return result
  end
  
end