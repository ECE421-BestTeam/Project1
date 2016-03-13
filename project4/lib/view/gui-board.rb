require 'gtk2'
require_relative '../controller/board'

# should not contain any logic as it is the view
class GuiBoard
  
  # creates the board and sets the listeners
  def initialize (players, victoryType, commType, &close)

    @players = players
    @victoryType = victoryType
    @controller = BoardController.new(commType)
    Gtk.init

    # set up the window
    @window = Gtk::Window.new
    @window.signal_connect("destroy") do
      close.call(@model) if close
      @controller.close if @controller
      Gtk.main_quit
    end
    @window.title = "Connect4.2 Game"
#    window.border_width = 10

    startGame
    
    Gtk.main

  end
  
  # attempts to start game
  def startGame
    # sends options (@players, @victoryType, etc)
    @controller.startGame(@players, @victoryType)
    showBoard(@controller.board)
  end
  
  # Builds and shows the base game board
  def showBoard(model)
    #build the board
    board = Gtk::Table.new(model.rows, model.cols)
    board = Gtk::Label.new('TODO make board')
    
    @board = board
    @window.add @board
    @window.show_all
    
    #update the board
    refreshBoard model
    
    #register the handle listeners (which will take care of turn progression
#    @handler.placeToken(col, row, token,
#      Proc.new { |model| refreshBoard(model) }, #success
#      Proc.new { |err| } #failure
#    )
  end
  
  # refreshes board to reflect the current model
  def refreshBoard(model)
    @model = model
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

GuiBoard.new 1, 0, 0