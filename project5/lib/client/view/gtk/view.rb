require 'gtk2'
require_relative './helper'
require_relative './board'
require_relative '../../controller/menu'

# should not contain any logic as it is the view
class GtkView
  
  # creates the board and sets the listeners
  def initialize
    # the menu options
    @controller = MenuController.new
    @gameSettings = GameSettingsModel.new
    @gameSettings.players = 1;
    setupWindow
  end
  
  def setupWindow
    Gtk.init

    # set up the window
    @window = Gtk::Window.new
    GtkHelper.applyEventHandler(@window, "destroy") do
      Gtk.main_quit
    end
    @window.title = "Connect4.2"
    
    panels = Gtk::VBox.new
    
    gameButton = Gtk::Button.new "Game"
    accountButton = Gtk::Button.new "Account"
    serverButton = Gtk::Button.new "Server"
    statsButton = Gtk::Button.new "Stats"
    GtkHelper.applyEventHandler(gameButton, :clicked) {switchContext :game}
    GtkHelper.applyEventHandler(accountButton, :clicked) {switchContext :account}
    GtkHelper.applyEventHandler(serverButton, :clicked) {switchContext :server}
    GtkHelper.applyEventHandler(statsButton, :clicked) {switchContext :stats}
    menu = GtkHelper.createBox('H',
      [ { :widget => gameButton },
        { :widget => accountButton },
        { :widget => serverButton },
        { :widget => statsButton } ] )
    panels.pack_start menu
    
    @mainPanel = Gtk::EventBox.new
    panels.add @mainPanel
    
    window.add panels
    
    initNewGameWidget
    initGameBoardWidget
    initLoginWidget
    initLogoutWidget
    initServerWidget
    initStatsWidget
    
    switchContext :game
    @window.show_all
    
    Gtk.main
  end
  
  def switchContext(newContext)
    #TODO
  end
  
  # attempts to start game
  def startGame(boardControllerType)
    # sends options and create a custom boardController
    @bController = @controller.getBoardController(boardControllerType, @gameSettings)
    #TODO: start board
  end
  
  def initNewGameWidget
    @gameSettings = GameSettingsModel.new
    
    @newGameWidget = Gtk::VBox.new
    @newGameWidget.pack_start Gtk::Label.new "Welcome to Connect4.2!\nPractice in local mode:"
    players1 = Gtk::RadioButton.new "1"
    GtkHelper.applyEventHandler(players1, :clicked) {@gameSettings.players = 1}
    players2 = Gtk::RadioButton.new players1, "2"
    GtkHelper.applyEventHandler(players2, :clicked) {@gameSettings.players = 2}
    players = GtkHelper.createBox('H', 
      [ { :type => Gtk::Label, :content => "Players: " },
        { :widget => players1 },
        { :widget => players2 } ] )
    @newGameWidget.pack_start players
    
    victoryNormal = Gtk::RadioButton.new "Normal"
    GtkHelper.applyEventHandler(victoryNormal, :clicked) {@controller.victoryType = 'victoryNormal'}
    victoryOtto = Gtk::RadioButton.new victoryNormal, "OTTO/TOOT"
    GtkHelper.applyEventHandler(victoryOtto, :clicked) {@controller.victoryType = 'victoryOtto'}
    victory = GtkHelper.createBox('H', 
      [ { :type => Gtk::Label, :content => "Game Mode: " },
        { :widget => victoryNormal },
        { :widget => victoryOtto } ] )
    @newGameWidget.pack_start victory
    
    playButton = Gtk::Button.new "Play"
    GtkHelper.applyEventHandler(playButton, :clicked) {startGame}
    @newGameWidget.pack_start playButton
    @serverGameListWidget = Gtk::Label.new "[server games go here]"
    @newGameWidget.pack_start @serverGameListWidget
  end
  
  def initGameBoardWidget
  end
  
  def initLoginWidget
  end
  
  def initLogoutWidget
  end
  
  def initServerWidget
    @serverWidget = Gtk::VBox.new
    @serverWidget.pack_start Gtk::Entry.new
    addressEntry = Gtk::Entry.new
    #TODO: add event handler
    @serverWidget.pack_start GtkHelper.createBox('H', 
      [ { :type => Gtk::Label, :content => "Server Address: " },
        { :widget => addressEntry } ] )
    connectButton = Gtk::Button.new "Connect"
    #TODO: add event handler
    @serverWidget.pack_start connectButton
    @serverConnectionResult = Gtk::Label.new ""
    @serverWidget.pack_start @serverConnectionResult
  end
  
  def updateServerWidget
    #Update serverConnectionResult based on how the server connected
  end
  
  def initStatsWidget
    @statsWidget = Gtk::VBox.new
    @statsWidget.pack_start Gtk::Label.new "Top Player Stats:"
    @topPlayerStatsWidget = Gtk::Label.new "[database stats go here]"
    @statsWidget.pack_start @topPlayerStatsWidget
    @statsWidget.pack_start Gtk::Label.new "Your Stats:"
    @yourStatsWidget = Gtk::Label.new "[player stats go here]"
    @statsWidget.pack_start @yourStatsWidget
  end
  
  def updateStatsWidget
    #update topPlayerStatsWidget and yourStatsWidget based on connection and account info
  end
end