require 'xmlrpc/client'
require_relative './contract-victory'


# produces the desired victory object
class VictoryModel
  include XMLRPC::Marshallable
  include VictoryContract
  
  attr_reader :winningrow
  
  # victoryType - number: 0 = normal, 1 = OTTO
  def initialize (victoryType)
    pre_initialize(victoryType)
    
    case victoryType
      when 'victoryNormal'
        #@implementation = VictoryNormal.new
        init("Normal", [' ', 'O', 'X'], [1,1,1,1], [2,2,2,2])
      when 'victoryOtto'
        #@implementation = VictoryOtto.new
        init("OTTO", [' ', 'O', 'T'], [1,2,2,1],[2,1,1,2])
      else
        raise "Not a valid game mode"
    end

    post_initialize
    class_invariant
  end
  
  attr
  def init(name, tokens, p1sequence, p2sequence)
    @name = name
    @playerTokens = tokens
    @p1win = p1sequence
    @p2win = p2sequence
  end
  
  def name
    pre_name
    
    result = @name
    
    post_name(result)
    class_invariant
    return result
  end
  
  def playerToken(player)
    pre_playerToken(player)
    
    result = @playerTokens[player]
    
    post_playerToken(result)
    class_invariant
    return result
  end
  
  # checks if a victory condition is met
  # board - 2D array filled with nil/player1Token/player2Token
  # returns: nil - no victory, :player1 - p1 won, :player2 - p2 won, :draw p1 + p2 won
  def checkVictory(board)
    pre_checkVictory(board)
    
    # make bidirectional diagonals
    diags = makeDiags(board)
    # p1 victory
    if checkArrays(board.transpose, @p1win) || checkArrays(board, @p1win) || checkArrays(diags, @p1win)
      result = 1
    # p2 victory
    elsif checkArrays(board.transpose, @p2win) || checkArrays(board, @p2win) || checkArrays(diags, @p2win)
      result = 2
    elsif boardFull(board)
      result = 3
    else
      result = 0
    end

    
    post_checkVictory(result)
    class_invariant
    return result
  end
  
  def checkArrays (arrs, win)
    (0...arrs.size).each{ |a|
      arrs[a].each_index{ |r|
        result = true
        (0...win.size).each { |i|
          result = result && arrs[a][r+i] == win[i]
        }
        return result if result == true
      }
    }
    return false
  end
  
  def boardFull(board)
    pre_boardFull(board)
    board.each_index { |c|
      board[c].each_index {|r|
        if board[c][r] == 0
          return false
        end
      }
    }
    post_boardFull
    return true
  end
  
  def makeDiags(arrs)
    diags =  (generateDiags(arrs) + generateDiags(arrs.transpose))
    return diags
  end

  def generateDiags(arrs)
    diags = []
    #SE direction
    arrs[0].size.times { |k|
      diags << (0...arrs.size).collect{ |i| arrs[i][i+k]}
      
    }
    (arrs[0].size-1).downto(0) { |k|
      diags << (arrs.size-1).downto(0).collect{ |i| arrs[i][i-k] if i-k > -1}
    }
        #SW direction
    arrs[0].size.times { |k|
      diags << (0...arrs.size).collect{ |i| arrs[i][k-i] if k-i > -1}
    }
    (arrs[0].size-1).downto(0) { |k|
      diags << (arrs.size-1).downto(0).collect{ |i| arrs[i][k-(i-(arrs[0].size-1))] if i-k > -1}
    }
    return diags
  end
  
end