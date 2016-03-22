require 'gtk2'
require_relative './gtk-helper'
require_relative '../controller/board'

# should not contain any logic as it is the view
class BoardGtk
  
  #controller - a BoardController
  def initialize (controller, exitCallback = Proc.new {})

    @controller = controller
    # pull settings we will use frequently, they are constant
    @rows = @controller.settings.rows
    @cols = @controller.settings.cols
    @localPlayers = @controller.localPlayers
    @exitCallback = exitCallback
    
    # for displaying issues
    @currentLocation = File.expand_path File.dirname(__FILE__)

    # set up the window
    Gtk.init
    @window = Gtk::Window.new
    GtkHelper.applyEventHandler(@window, "destroy") do
      exitGame
    end
    @window.title = "Connect4.2 Game"
#    window.border_width = 10
    
    # set up the board
    setUpBoard
    refreshBoard @controller.startGame
    
    Gtk.main

  end
  
  def exitGame
      @controller.close if @controller.close
      @exitCallback.call(@game)
      Gtk.main_quit
  end
  
  # Builds the base game board
  def setUpBoard
    
    createPlaceButton = Proc.new do |col|
      {
        :type => Gtk::Button,
        :content => "Place",
        :listeners => [
          { 
            :event => :clicked, 
            :action => Proc.new { 
              refreshBoard(@controller.placeToken(col)) 
              refreshBoard(@controller.getNextActiveState) 
            } 
          }
        ]
      }
    end
    
    buttons = []
    (0..(@cols-1)).each do |col|
      buttons.push(createPlaceButton.call(col))
    end
    buttons = GtkHelper.createBox('H', buttons)
    
    #build the board
    board = Gtk::Table.new(@rows, @cols)

    @cells = Array.new(@rows) { Array.new(@cols) {nil} }

    (0..(@cols-1)).each do |col|
      (0..(@rows-1)).each do |row|
        cell = Gtk::EventBox.new
        cell.add(Gtk::Image.new("#{@currentLocation}/image/empty.png"))
        GtkHelper.applyEventHandler(cell, "button_press_event") {
          refreshBoard(@controller.placeToken(col))
          refreshBoard(@controller.getNextActiveState)
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
  def refreshBoard(game)
    @game = game
    if !@player1token
      @player1token = game.settings.victoryType == :victoryNormal ? "#{@currentLocation}/image/token0.png" : "#{@currentLocation}/image/tokenO.png"
    end
    if !@player2token
      @player2token = game.settings.victoryType == :victoryNormal ? "#{@currentLocation}/image/token1.png" : "#{@currentLocation}/image/tokenT.png"
    end
    if !@emptytoken
      @emptytoken = "#{@currentLocation}/image/empty.png"
    end
    puts 'refreshed'
    # check for victory (if so do something like switch to end screen)
    
    #check which player's turn it is (disable/enable buttons)
    
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
  end
  
  # graphically displays token at given location
  # col - 0 indexed from the left
  # row - 0 indexed from the bottom up
  # token - the token to place: nil = empty token, 
  def placeToken (col, row, token = nil)
    
  end
  
end
