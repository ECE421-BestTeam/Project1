require_relative './contract-board'
require_relative './helper'

# should not contain any logic as it is the view
class ViewCmdBoard
  include CmdBoardViewContract
  
  #controller - a BoardController
  def initialize (controller, exitCallback)
    pre_initialize(controller, exitCallback)
    
    @exitCallback = exitCallback
    @controller = controller
    
    # pull settings we will use frequently, they are constant
    @rows = @controller.settings.rows
    @cols = @controller.settings.cols
    @localPlayers = @controller.localPlayers

    @helper = CmdHelper.new(Proc.new {exitGame})
    
    @gameover = false
    @controller.registerRefresh(method(:refresh))
    
    post_initialize
  end
    
  def exitGame
    @gameover = true
    @exitCallback.call @controller.close
  end
  
  def refresh(game)
    # don't let additional calls go through if game is over
    return if @gameover
    
    @game = game
    
    # re-display the board
    puts boardToString
    
    # Check if the game is over
    if @game.winner != 0
      puts "--- GAME OVER ---"
      if @game.winner == 3
        puts "Draw!"
      elsif @game.winner == 1
        puts "Player 1 wins!"
      elsif @game.winner == 2
        puts "Player 2 wins!"
      end
        exitGame
      return
    end

    # if it is a player turn, let them take their turn!
    playerTurn = @game.turn % 2
    
    if @localPlayers.include?playerTurn #it is a local player's turn
      puts "Player #{playerTurn + 1}'s turn:"
      @helper.getUserInput(
        "Choose a column to place your token ('#{getToken(playerTurn)}') in. (1 to #{@cols})", 
        (1..@cols), 
        Proc.new do |col|
          @controller.placeToken(col - 1)
        end
      )
    else
      puts "Opponent's Turn..."
    end
   
  end
  
  def boardToString
    result = ""
    (1..@cols).each {|n| result += "=#{n}"}
    result += "=\n"
    @game.board.each do |row|
      result += "|"
      row.each do |val|
        result += "#{getToken(val)}|"
      end
      result += "\n"
    end
    (1..@cols).each {result += "=="}
    result += "=\n"
  end
  
  # graphically displays token at given location
  # col - 0 indexed from the left
  # row - 0 indexed from the bottom up
  # token - the token to place: nil = empty token, 
  def getToken (val)
    if val == nil
      return " "
    else
      begin
        return @game.victory.playerToken(val) 
      rescue Exception 
        return "?"
      end
    end
  end
  
end