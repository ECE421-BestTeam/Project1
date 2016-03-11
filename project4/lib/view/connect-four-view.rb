require 'gtk2'
require_relative '../controller/game-handler'

# should not contain any logic as it is the view
class ConnectFourView
  
  # creates the board and sets the listeners
  # handlers - should be a hash which defines the actions
  def initialize (handler = GameHandler.new)

    @handler = handler
    
    Gtk.init

    # set up the window
    @window = Gtk::Window.new
    @window.signal_connect("destroy") do
      @handler.close
      Gtk.main_quit
    end
    @window.title = "Connect4.2"
#    window.border_width = 10

    # initialize menu options
    @menuHash = {}
    @players = 1
    @victoryType = 0
    @commType = 0
    
#    @window.show
    
    showMenu
    
    Gtk.main

  end
  
  def showMenu
#    @screen.pack_
    menu = Gtk::VBox.new
    
    # build options and listeners
       
    players1 = Gtk::RadioButton.new "1"
    players1.signal_connect(:clicked) {@players = 1}
    players2 = Gtk::RadioButton.new players1, "2"
    players2.signal_connect(:clicked) {@players = 2}

    players = createBox('H', 
      [
        {
          :type => Gtk::Label,
          :content => "Players: "
        },
        {
          :widget => players1
        },
        {
          :widget => players2
        }
      ]
    )
    menu.pack_start players
    
    victoryNormal = Gtk::RadioButton.new "Normal"
    victoryNormal.signal_connect(:clicked) {@victoryType = 0}
    victoryOtto = Gtk::RadioButton.new victoryNormal, "OTTO/TOOT"
    victoryOtto.signal_connect(:clicked) {@victoryType = 1}
    victory = createBox('H', 
      [
        {
          :type => Gtk::Label,
          :content => "Game Mode: "
        },
        {
          :widget => victoryNormal
        },
        {
          :widget => victoryOtto
        }
      ]
    )
    menu.pack_start victory
    
    #refresh the menu's values
    
    if @players == 2
      players1.set_active false
      players2.set_active true
    else
      #default
      players1.set_active true
      players2.set_active false
      @players = 1
    end
    
    if @players == 1
      victoryNormal.set_active false
      victoryOtto.set_active true
    else
      #default
      victoryNormal.set_active true
      victoryOtto.set_active false
      @victoryType = 0
    end
    
    @window.add menu
    
    @window.show_all

  end
  
  def createElement(element)
    if element[:widget]
      return element[:widget]
    end
    
    el = element[:type].new(element[:content])
    if element[:listeners]
      element[:listeners].each do |listener|
        el.signal_connect(listener[:event]) {listener[:action].call}
      end
    end
    return el
  end
  
  def createBox(type, elements)
    box = nil
    
    if type == 'V'
      box = Gtk::VBox.new
    else
      box = Gtk::HBox.new
    end
    
    elements.each do |element|
      box.pack_start createElement(element)
    end
    
    return box
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

ConnectFourView.new();