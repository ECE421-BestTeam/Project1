require 'gtk2'
require_relative './helper'
require_relative '../../controller/board'

# should not contain any logic as it is the view
class ViewGtkBoard
  attr_accessor :board
  
  #controller - a BoardController
  def initialize (window, widget, controller, exitCallback = Proc.new {|game|})
    # pull settings we will use frequently, they are constant
    @window = window
    @widget = widget
    @controller = controller
    @localPlayers = @controller.localPlayers
    @exitCallback = exitCallback
    
    # for displaying issues
    @currentLocation = File.expand_path File.dirname(__FILE__)
    
    @extrasVbox = Gtk::VBox.new
    @window.show_all
    
    @gameover = false
    @controller.registerRefresh(method(:refresh))
  end
  
  def exitGame
    @gameover = true
    @exitCallback.call @controller.close
  end
  
  # Builds the base game board
  def setUpBoard
    # get the tokens
    @player1token = @game.victory.playerToken(2) == 'X' ? "#{@currentLocation}/image/token0.png" : "#{@currentLocation}/image/tokenO.png"
    @player2token = @game.victory.playerToken(2) == 'X' ? "#{@currentLocation}/image/token1.png" : "#{@currentLocation}/image/tokenT.png"
    @emptytoken = "#{@currentLocation}/image/empty.png"
    
    #build the board
    board = Gtk::Table.new(@game.settings.rows, @game.settings.cols)

    @cells = Array.new(@game.settings.rows) { Array.new(@game.settings.cols) {nil} }

    (0..(@game.settings.cols-1)).each do |col|
      (0..(@game.settings.rows-1)).each do |row|
        cell = Gtk::EventBox.new
        cell.add(Gtk::Image.new("#{@currentLocation}/image/empty.png"))
        GtkHelper.applyEventHandler(cell, "button_press_event") {
          @controller.placeToken(col)
        }
        board.attach(cell,col,col+1,row,row+1,Gtk::FILL,Gtk::FILL)
        @cells[row][col] = cell
      end
    end
    
    @board = board
    @widget.pack_start @board
    @widget.pack_start @extrasVbox
    @window.show_all
  end
  
  def refresh(content)
    # don't let additional calls go through if game is over
    return if @gameover
    
    @extrasVbox.children.each do |widget|
      widget.destroy
    end
    
    data = content['data']
    case content['type']
      when 'game'
        updateGame(data)
      when 'saveRequest'
        # handles sending back to the server a saveAgree request
        @extrasVbox.pack_start Gtk::Label.new "Opponent has requested to save."
        acceptButton = Gtk::Button.new "Accept"
        declineButton = Gtk::Button.new "Decline"
        GtkHelper.applyEventHandler(acceptButton, :clicked) {
          @controller.sendSaveResponse(true)
          @extrasVbox.children.each do |widget|
            widget.destroy
          end
          exitGame
        }
        GtkHelper.applyEventHandler(declineButton, :clicked) {
          @controller.sendSaveResponse(false)
          @extrasVbox.children.each do |widget|
            widget.destroy
          end
        }
        @extrasVbox.pack_start GtkHelper.createBox('H', 
          [ { :widget => acceptButton },
            { :widget => declineButton } ] )
        @window.show_all
      when 'saveResponse'
        if data
          @extrasVbox.pack_start Gtk::Label.new "Opponent has agreed to save."
          okButton = Gtk::Button.new "OK"
          GtkHelper.applyEventHandler(okButton, :clicked) {
            @extrasVbox.children.each do |widget|
              widget.destroy
            end
            exitGame
          }
          @extrasVbox.pack_start okButton
          @window.show_all
        else
          @extrasVbox.pack_start Gtk::Label.new "Opponent has not agreed to save."
          okButton = Gtk::Button.new "OK"
          GtkHelper.applyEventHandler(okButton, :clicked) {
            @extrasVbox.children.each do |widget|
              widget.destroy
            end
          }
          @extrasVbox.pack_start okButton
          @window.show_all
        end
        updateGame(@game)
    end
  end
  
  def updateGame(game)
    return if !(!@game || game.turn >= @game.turn)
    @game = game 
    
    # re-display the board
    updateBoard

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
        Proc.new do |col|
          if col == "save"
            #sends a requestSave request
            @controller.sendSaveRequest
            puts '...'
          elsif ans == 'forfeit'
            @controller.sendForfeit
            exitGame
          else
            @controller.placeToken(col - 1)
          end
        end
      )
    else
      puts "Opponent's Turn..."
    end
   end
  
  # refreshes board to reflect the current model
  def updateBoard
    setUpBoard if @board == nil
    
    # update tokens
    (0..(@game.settings.cols-1)).each do |col|
      (0..(@game.settings.rows-1)).each do |row|
        case @game.board[row][col]
        when 0
          @cells[row][col].children[0].set_file(@player1token)
        when 1
          @cells[row][col].children[0].set_file(@player2token)
        else
          @cells[row][col].children[0].set_file(@emptytoken)
        end
      end
    end
  end
end