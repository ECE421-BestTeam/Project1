require_relative './cmd-helper'
require_relative '../controller/board'

# should not contain any logic as it is the view
class BoardCmd
  
  #controller - a BoardController
  def initialize (controller, exitCallback)

    @exitCallback = exitCallback
    @controller = controller
    
    # pull settings we will use frequently, they are constant
    @rows = @controller.settings.rows
    @cols = @controller.settings.cols
    @localPlayers = @controller.localPlayers

    @game = @controller.startGame
    @helper = CmdHelper.new(Proc.new {gameover})
    @gameover = false
    loop
  end
  
  def loop
    
    while !@gameover
      #We really shouldn't ever catch anything here
      begin
        turn
      rescue ArgumentError => e
        puts "ERROR: e"
        @gameover = true
      end
    end

  end
  
  def gameover
    @gameover = true

    puts "--- GAME OVER ---"
    if @game.winner != 0
      if @game.winner == 3
        puts "Draw!"
      else
        puts "Player #{@game.winner} wins!"
      end
    end

    puts "ENTER to continue:"
    gets
    
    @controller.close
    @exitCallback.call @game
  end
  
  
  # Handles a localPlayer Turn
  # returns false if the game is over
  def turn
    puts boardToString
    
    if @game.winner != 0
      gameover
      return
    end
    
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
      @controller.getNextActiveState
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