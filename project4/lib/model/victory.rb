require_relative './contract-victory'
require_relative './victory-normal'
require_relative './victory-otto'
require_relative './victory-cond'

# produces the desired victory object
class VictoryModel
  include VictoryContract
  
  # victoryType - number: 0 = normal, 1 = OTTO
  def initialize (victoryType)
    pre_initialize(victoryType)
    
    case victoryType
      when 0
        #@implementation = VictoryNormal.new
        @implementation = VictoryCond.new("Normal", ['O', 'X'], ['O','O','O','O'],['X','X','X','X'])
      when 1
        #@implementation = VictoryOtto.new
        @implementation = VictoryCond.new("OTTO", ['O', 'T'], ['O','T','T','O'],['T','O','O','T'])
    end

    post_initialize
    class_invariant
  end
  
  
  def name
    pre_name
    
    result = @implementation.name
    
    post_name(result)
    class_invariant
    return result
  end
  
  def playerToken(player)
    pre_playerToken(player)
    
    result = @implementation.playerTokens[player]
    
    post_playerToken(result)
    class_invariant
    return result
  end
  
  # checks if a victory condition is met
  # board - 2D array filled with nil/player1Token/player2Token
  # returns: 0 - no victory, 1 - p1 won, 2 - p2 won, 3 p1 + p2 won
  def checkVictory(board)
    pre_checkVictory(board)
    
    result = @implementation.checkVictory(board)
        
    post_checkVictory(result)
    class_invariant
    return result
  end
  
end