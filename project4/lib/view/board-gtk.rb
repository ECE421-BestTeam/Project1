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

    setUpBoard exitCallback
    refreshBoard @controller.startGame
    
    Gtk.main

  end
  
  # Builds and shows the base game board
  def setUpBoard(exitCallback)
    # set up the window
    Gtk.init
    @window = Gtk::Window.new
    @window.signal_connect("destroy") do
      @controller.close(@game) if @controller.close
      Gtk.main_quit
      exitCallback.call(@game) if exitCallback
    end
    @window.title = "Connect4.2 Game"
#    window.border_width = 10
    
    #build the board
    board = Gtk::Table.new(@rows, @cols)
    board = Gtk::Label.new('TODO make board')
    
    @board = board
    @window.add @board
    @window.show_all
    
    #register the handle listeners (which will take care of turn progression
#    @handler.placeToken(col, row, token,
#      Proc.new { |game| refreshBoard(game) }, #success
#      Proc.new { |err| } #failure
#    )
  end
  
  # refreshes board to reflect the current model
  def refreshBoard(game)
    @game = game
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
  
  def applyEventHandler (widget, event, &handler)
    
  end
  
end