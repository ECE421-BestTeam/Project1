require 'gtk2'
require_relative '../controller/board'

# should not contain any logic as it is the view
class GuiBoard
  
  # creates the board and sets the listeners
  def initialize (controller, game, exitCallback)

    @controller = controller
    Gtk.init

    # set up the window
    @window = Gtk::Window.new
    @window.signal_connect("destroy") do
      @controller.close if @controller
      Gtk.main_quit
      exitCallback.call(@game) if exitCallback
    end
    @window.title = "Connect4.2 Game"
#    window.border_width = 10

    showBoard(game)
    
    Gtk.main

  end
  
  # Builds and shows the base game board
  def showBoard(game)
    #build the board
    board = Gtk::Table.new(game.rows, game.cols)
    board = Gtk::Label.new('TODO make board')
    
    @board = board
    @window.add @board
    @window.show_all
    
    #update the board
    refreshBoard game
    
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
  
  # col - 0 indexed from the left
  # row - 0 indexed from the bottom up
  # token - the token to place
  def placeToken (col, row, token)
    
  end
  
end

#GuiBoard.new nil, nil, Proc.new {puts 'hi'}