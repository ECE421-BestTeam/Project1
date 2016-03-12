require 'gtk2'
require_relative '../controller/handler-factory'

# should not contain any logic as it is the view
class ConnectFourView
  
  # creates the board and sets the listeners
  def initialize ()

    Gtk.init

    # set up the window
    @window = Gtk::Window.new
    @window.signal_connect("destroy") do
      @handler.close if @handler
      Gtk.main_quit
    end
    @window.title = "Connect4.2"
#    window.border_width = 10

    # initialize menu options
    @menuHash = {}
    @players = 1
    @victoryType = 0
    @handlerType = 0
    
#    @window.show
    
    showMenu
    
    Gtk.main

  end
  
  # shows the menu and allows the user set options
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
    
    start = createBox('H', 
      [
        {
          :type => Gtk::Label,
          :content => "Start Game!",
          :listeners => [
            { 
              :event => :clicked, 
              :action => Proc.new {startGame} 
            }
          ]
        }
      ]
    )
    menu.pack_start start
    
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
  
  # attempts to start game
  def startGame
    # chooses the correct controller
    @handler = HandlerFactory.new @commType
    
    # sends options (@players, @victoryType, etc)
    begin
      model = @handler.startGame(@players, @victoryType) do |model|
        refreshBoard(model)
      end
    rescue
      # we failed to join a game for some reason
    else
      # we have successfully joined a game
      showBoard(model)
    end
  end
  
  # Builds and shows the base game board
  def showBoard(model)
    #build the board
    
    #update the board
    refreshBoard model
    
    #register the handle listeners (which will take care of turn progression
  end
  
  # refreshes board to reflect the current model
  def refreshBoard(model)
    # check for victory (if so do something like switch to end screen)
    
    #check which player's turn it is (disable/enable buttons)
    
    # update tokens
  end
  
  # col - 0 indexed from the left
  # row - 0 indexed from the bottom up
  # token - the token to place
  def placeToken (col, row, token)
    
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
  
end