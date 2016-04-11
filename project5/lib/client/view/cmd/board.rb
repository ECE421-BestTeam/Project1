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
    @localPlayers = @controller.localPlayers

    @helper = CmdHelper.new(Proc.new {exitGame}, Proc.new {@gameover})
    trap("SIGINT") do
      puts "\nExitGame"
      @helper.quit
      exitGame
    end
    
    @gameover = false
    @controller.registerRefresh(method(:refresh))
    
    post_initialize
  end
    
  def exitGame
    @gameover = true
    @exitCallback.call @controller.close
  end
  
  def refresh(content)
    # don't let additional calls go through if game is over
    return if @gameover
    
    data = content['data']
    case content['type']
      when 'game'
        updateGame(data)
      when 'saveRequest'
        # handles sending back to the server a saveAgree request
        @helper.getUserInput(
          "Opponent has requested to save. 'y' to agree, 'n' to disagree and forfeit match",
          ['y','n'],
          Proc.new do |ans|
            if ans == 'y'
              puts 'Saved game'
              @controller.sendSaveResponse(true)
              exitGame
            else
              @controller.sendSaveResponse(false)
            end
          end
        )
      when 'saveResponse'
        if data
          puts 'Oppenent agreed to save'
          exitGame
        else
          puts 'Oppenent did no agree to save'
          updateGame(@game)
        end
    end
  end
  
  def updateGame(game)
    return if !(!@game || game.turn >= @game.turn)
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
    playerTurn = (@game.turn % 2) + 1

    if @localPlayers.include?playerTurn #it is a local player's turn
      puts "Player #{playerTurn}'s turn:"
      
      @helper.getUserInput(
        "Choose a column to place your token ('#{getToken(playerTurn)}') in. (1 to #{@game.settings.cols}).  Or enter 'save' to send a save request.  Or 'forfeit' to forfeit.", 
        (1..@game.settings.cols).to_a.push("save").push('forfeit'),
        Proc.new do |res|
          if res == "save"
            #sends a requestSave request
            @controller.sendSaveRequest
            puts '...'
          elsif res == 'forfeit'
            @controller.sendForfeit
            exitGame
          else
            @controller.placeToken(res - 1)
          end
        end
      )
    else
      puts "Opponent's Turn..."
    end
   
  end
  
  def boardToString
    cols = @game.settings.cols
    result = ""
    (1..cols).each {|n| result += "=#{n}"}
    result += "=\n"
    @game.board.each do |row|
      result += "|"
      row.each do |val|
        result += "#{getToken(val)}|"
      end
      result += "\n"
    end
    (1..cols).each {result += "=="}
    result += "=\n"
  end
  
  # graphically displays token at given location
  # col - 0 indexed from the left
  # row - 0 indexed from the bottom up
  # token - the token to place: nil = empty token, 
  def getToken(val)
    if val == 0
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