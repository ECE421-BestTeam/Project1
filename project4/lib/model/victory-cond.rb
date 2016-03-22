# the model for normal Victory
class VictoryCond
  
  attr_reader :name, :playerTokens
  
  def initialize (name, tokens, p1sequence, p2sequence)
    @name = name
    @playerTokens = tokens
    @p1win = p1sequence
    @p2win = p2sequence
  end
  
  def newPlayer(playernum, token, wincondition)
    
  end
  
  # checks if a victory condition is met
  # board - 2D array filled with nil/player1Token/player2Token
  # returns: 0 - no victory, 1 - p1 won, 2 - p2 won, 3 p1 + p2 won
  def checkVictory(board)
    # make bidirectional diagonals
    diags = makeDiags(board)
    # p1 victory
    return :player1 if checkArrays(board.transpose, @p1win) \
      || checkArrays(board, @p1win) \
      || checkArrays(diags, @p1win)
    # p2 victory
    return :player2 if checkArrays(board.transpose, @p2win) \
      || checkArrays(board, @p2win) \
      || checkArrays(diags, @p2win)
      
    board.each_index { |c|
      board[c].each_index {|r|
        return nil if board[c][r].nil?
        }
    }
    
    return :draw
  end
  
  def checkArrays (arrs, win)
    arrs.each{ |row|
      if row.size < win.size then
        next
      end
      row.each_with_index{ |_, r|
        result = true
        (0..win.size).each { |i|
          result = result && row[r+i] == win[i]
        }
        return result if result == true
      }
    }
    return false

  end
  
  def makeDiags(arrs)
    return (generateDiags(arrs) + generateDiags(arrs.transpose)).uniq.reject(&:empty?)
  end
  
  def generateDiags(arrs)
    diags = []
    #SE direction
    arrs[0].size.times { |k|
      diags << (0...arrs.size).collect{ |i| arrs[i][i+k]}.compact
    }
    (arrs[0].size-1).downto(0) { |k|
      diags << (arrs.size-1).downto(0).collect{ |i| arrs[i][i-k] if i-k > -1}.compact
    }
    #SW direction
    arrs[0].size.times { |k|
      diags << (0...arrs.size).collect{ |i| arrs[i][k-i] if k-i > -1}.compact
    }
    (arrs[0].size-1).downto(0) { |k|
      diags << (arrs.size-1).downto(0).collect{ |i| arrs[i][k-(i-(arrs[0].size-1))] if i-k > -1}.compact
    }
    return diags
    
  end
end