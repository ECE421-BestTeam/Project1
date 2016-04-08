require 'gtk2'
require_relative './helper'
require_relative '../../controller/board'

# should not contain any logic as it is the view
class ViewGtkBoard
  
  #controller - a BoardController
  def initialize (controller, exitCallback = Proc.new {|game|})

    @controller = controller
    # pull settings we will use frequently, they are constant
    @rows = @controller.settings.rows
    @cols = @controller.settings.cols
    @localPlayers = @controller.localPlayers
    @exitCallback = exitCallback
    
    # for displaying issues
    @currentLocation = File.expand_path File.dirname(__FILE__)

    # set up the window
    @window = Gtk::Window.new
    GtkHelper.applyEventHandler(@window, "destroy") do
      exitGame
    end
    @window.title = "Connect4.2 Game"
#    window.border_width = 10

  # set up the board
    setUpBoard
    refreshBoard @controller.startGame, true

    Gtk.main

  end
  
  def exitGame
    @controller.close if @controller.close
    @exitCallback.call(@game)
    Gtk.main_quit
  end
  
  # Builds the base game board
  def setUpBoard
    # get the tokens
    @player1token = @controller.settings.victoryType == :victoryNormal ? "#{@currentLocation}/image/token0.png" : "#{@currentLocation}/image/tokenO.png"
    @player2token = @controller.settings.victoryType == :victoryNormal ? "#{@currentLocation}/image/token1.png" : "#{@currentLocation}/image/tokenT.png"
    @emptytoken = "#{@currentLocation}/image/empty.png"
    
    #build the board
    board = Gtk::Table.new(@rows, @cols)

    @cells = Array.new(@rows) { Array.new(@cols) {nil} }

    (0..(@cols-1)).each do |col|
      (0..(@rows-1)).each do |row|
        cell = Gtk::EventBox.new
        cell.add(Gtk::Image.new("#{@currentLocation}/image/empty.png"))
        GtkHelper.applyEventHandler(cell, "button_press_event") {
          refreshBoard(@controller.placeToken(col))
        }
        board.attach(cell,col,col+1,row,row+1,Gtk::FILL,Gtk::FILL)
        @cells[row][col] = cell
      end
    end
    
    @board = board
    @window.add @board
    @window.show_all

  end
  
  # refreshes board to reflect the current model
  def refreshBoard(game, recursive = false)
    @game = game

    # update tokens
    (0..(@cols-1)).each do |col|
      (0..(@rows-1)).each do |row|
        case game.board[row][col]
        when 0
          @cells[row][col].children[0].set_file(@player1token)
        when 1
          @cells[row][col].children[0].set_file(@player2token)
        else
          @cells[row][col].children[0].set_file(@emptytoken)
        end
      end
    end
    
    # check for victory (if so do something like switch to end screen)
    if game.winner == 0
      refreshBoard(@controller.getNextActiveState, true) if !recursive
    else
      # else we have a winner
      message = "Draw!"
      if (@controller.settings.players == 1)
        message = "Player wins!" if game.winner == 1
        message = "Computer wins!" if game.winner == 2
      else
        message = "Player 1 wins!" if game.winner == 1
        message = "Player 2 wins!" if game.winner == 2
      end
#      @window.destroy
      GtkHelper.popUp("Game Over", message, Proc.new { @window.destroy })
    end
    
  end
  
end