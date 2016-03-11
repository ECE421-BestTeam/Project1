require 'gtk2'

# should not contain any logic as it is the view
class ConnectFourBoard
  
  # creates the board and sets the listeners
  # model - ../model/game object used to determine view
  # handlers - should be a hash which defines the actions
  def initialize (model, handlers)

    Gtk.init

    # set up the window
    @window = Gtk::Window.new
    @window.signal_connect("destroy") { Gtk.main_quit }
    @window.title = "Connect4.2"
#    window.border_width = 10

    
#button = Gtk::Button.new("Hello World")
#button.signal_connect("clicked") { puts "Hello World" }
#    window.add button
    
    @window.show_all
    Gtk.main

  end
  
  # builds the game board according to the current model
  def refreshBoard (model)
    
  end
  
  # col - 0 indexed from the left
  # row - 0 indexed from the bottom up
  # token - the token to place
  def placeToken (col, row, token)
    
  end
  
  # removes all tokens from the board
  def clearBoard 
    
  end
  
end

ConnectFourBoard.new({});