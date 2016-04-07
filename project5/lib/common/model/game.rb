require 'xmlrpc/client'
require_relative './contract-game'
require_relative './victory'

# the model for our game
class GameModel
  include XMLRPC::Marshallable
  include GameContract
  
  attr_reader :settings,
    :winner, # 0 = nowin, 1 = (player 1), 2 = (player 2), 3 = draw
    :victory, # victory object
    :turn, # even = (player 1 turn), or odd = (player 2 turn)
    :board
  
  # creates the board and sets the listeners
  # settings - a GameSettingsModel object
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
    
    raise GameOverError, "Game is over!" if @winner != nil
    
    freeRow = false
    
    # look through the col, starting from the bottom
    (0..(@settings.rows - 1)).each do |rowNum|
      row = @settings.rows - 1 - rowNum
      currentToken = @board[row][col]
      if currentToken == nil
        freeRow = row
        break
      end
    end
    
    raise ArgumentError, "Column is full!" if !freeRow
    
    # set playerToken in the lowest available column slot
    @board[freeRow][col] = @turn % 2
    # increment the turn
    @turn += 1
    # checkVictory
    checkVictory
    
    result = self
    
    post_placeToken(result)
    class_invariant
    return result
  end
  
  def computerTurn
    pre_computerTurn
    begin
      placeToken(rand(0..(@settings.cols-1))) # do something better (col might be full)
    rescue GameOverError
      # don't place
    rescue ArgumentError
      retry #silently retry
    end
    checkVictory
    result = self
    
    post_computerTurn(result)
    class_invariant
    return result
  end
  
  # checks for victory conditions
  # returns false - no winner, true - winner exists
  def checkVictory
    pre_checkVictory
    if @winner == nil
      @winner = @victory.checkVictory @board
    end
    result = @winner
    
    post_checkVictory(result)
    class_invariant
    return result
  end
  
end

class GameOverError < RuntimeError
  
end