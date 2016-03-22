require 'gtk2'
require_relative './gtk-helper'
require_relative '../controller/board'

# should not contain any logic as it is the view
class BoardGtk
  
  #controller - a BoardController
  def initialize (controller, exitCallback)

    @controller = controller
    # pull settings we will use frequently, they are constant
    @rows = @controller.settings.rows
    @cols = @controller.settings.cols
    @localPlayers = @controller.localPlayers
    
    # for displaying issues
    @currentLocation = File.expand_path File.dirname(__FILE__)

    # set up the window
    Gtk.init
    @window = Gtk::Window.new
    GtkHelper.applyEventHandler(@window, "destroy") do
      @controller.close if @controller.close
      exitCallback.call(@game) if exitCallback
      Gtk.main_quit
    end
    @window.title = "Connect4.2 Game"
#    window.border_width = 10
    
    # set up the board
    setUpBoard
    refreshBoard @controller.startGame
    
    Gtk.main

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

    (0..(@cols-1)).each do |col|
      (0..(@rows-1)).each do |row|
        cell = Gtk::EventBox.new
        cell.add(Gtk::Image.new("#{@currentLocation}/image/empty.png"))
        cell.signal_connect("button_press_event") {
          cell.children[0].set_file("#{@currentLocation}/image/token0.png")
        }
        board.attach(cell,col,col+1,row,row+1,Gtk::FILL,Gtk::FILL)
      end
    end
    
    @board = board
    @window.add @board
    @window.show_all

  end
  
  # refreshes board to reflect the current model
  def refreshBoard(game)
    @game = game
    puts 'refreshed'
    # check for victory (if so do something like switch to end screen)
    
    #check which player's turn it is (disable/enable buttons)
    
    # update tokens
  end
  
  # graphically displays token at given location
  # col - 0 indexed from the left
  # row - 0 indexed from the bottom up
  # token - the token to place: nil = empty token, 
  def placeToken (col, row, token = nil)
    
  end
  
end
