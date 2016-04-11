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
    
    @isGameInProgress = false
    
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
    GtkHelper.applyEventHandler(gameButton, :clicked) {
      switchContext :game if @currentContext != :game
    }
    GtkHelper.applyEventHandler(accountButton, :clicked) {
      switchContext :account if @currentContext != :account
    }
    GtkHelper.applyEventHandler(serverButton, :clicked) {
      switchContext :server if @currentContext != :server
    }
    GtkHelper.applyEventHandler(statsButton, :clicked) {
      switchContext :stats if @currentContext != :stats
    }
    menu = GtkHelper.createBox('H',
      [ { :widget => gameButton },
        { :widget => accountButton },
        { :widget => serverButton },
        { :widget => statsButton } ] )
    panels.pack_start menu
    
    @mainPanel = Gtk::EventBox.new
    panels.add @mainPanel
    
    @window.add panels
    
    initNewGameWidget
    initLoginWidget
    initLogoutWidget
    initServerWidget
    initStatsWidget
    
    switchContext :game
    @window.show_all
    
    Gtk.main
  end
  
  def switchContext(newContext)
    @mainPanel.remove @mainPanel.child if @mainPanel.child != nil
    case newContext
    when :game
      if @isGameInProgress
        @mainPanel.child = @gameBoardWidget
      else
        @mainPanel.child = @newGameWidget
        updateNewGameWidget
      end
    when :account
      if @controller.clientSettings.sessionId.length < 1
        @mainPanel.child = @loginWidget
        updateLoginWidget ''
      else
        @mainPanel.child = @logoutWidget
        updateLogoutWidget
      end
    when :server
        @mainPanel.child = @serverWidget
        updateServerWidget ''
    when :stats
        @mainPanel.child = @statsWidget
        updateStatsWidget
    else
    end
    @currentContext = newContext
    @window.resize(1,1) #Window resizes to smallest possible w/ all components shown
    @window.show_all
  end
  
  # attempts to start game
  def startGame(boardControllerType)
    # sends options and create a custom boardController
    @bController = @controller.getBoardController(boardControllerType, @gameSettings)
    @gameBoardWidget == VBox.new
    ViewGtkBoard.new(@window, @gameBoardWidget, @bController)
    @isGameInProgress = true
    switchContext :game
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
    GtkHelper.applyEventHandler(victoryNormal, :clicked) {@gameSettings.victoryType = 'victoryNormal'}
    victoryOtto = Gtk::RadioButton.new victoryNormal, "OTTO/TOOT"
    GtkHelper.applyEventHandler(victoryOtto, :clicked) {@gameSettings.victoryType = 'victoryOtto'}
    victory = GtkHelper.createBox('H', 
      [ { :type => Gtk::Label, :content => "Game Mode: " },
        { :widget => victoryNormal },
        { :widget => victoryOtto } ] )
    @newGameWidget.pack_start victory
    
    playButton = Gtk::Button.new "Play"
    GtkHelper.applyEventHandler(playButton, :clicked) {startGame 'local'}
    @newGameWidget.pack_start playButton
    @newGameWidget.pack_start Gtk::Label.new "Play online:"
    @serverGameListWidget = Gtk::EventBox.new
    @serverGameListWidget.child = Gtk::Label.new "[server games go here]"
    @newGameWidget.pack_start @serverGameListWidget
  end
  
  def updateNewGameWidget
    @serverGameListWidget.remove @serverGameListWidget.child if @serverGameListWidget.child != nil
    begin
      games = @controller.getGames
      scrollWindow = Gtk::ScrolledWindow.new
      vbox = Gtk::VBox.new
      newGameButton = Gtk::Button.new "New Game"
      GtkHelper.applyEventHandler(newGameButton, :clicked) {startGame 'online'}
      vbox.pack_start newGameButton
      displayServerGames(vbox, "Active Games", games['active'])
      displayServerGames(vbox, "Saved Games", games['saved'])
      displayServerGames(vbox, "Joinable Games", games['joinable'])
      scrollWindow.add_with_viewport vbox
      scrollWindow.set_size_request(400,200)
      @serverGameListWidget.child = scrollWindow
    rescue
      @serverGameListWidget.child = Gtk::Label.new "Connect to a server and log in/create an account to play Connect4.2 online."
    end
    @window.show_all
  end
  
  def displayServerGames(widget, title, games)
    widget.pack_start Gtk::Label.new "#{title}: #{games.size}"
    games.each_with_index do |gameEntry, i|
      game = gameEntry['game_model']
      button = Gtk::Button.new "Victory Mode: #{game.victory.name}, Turn: #{game.turn}"
      GtkHelper.applyEventHandler(button, :clicked) {
        @gameSettings = games[i]['game_id']
        startGame 'online'
      }
      widget.pack_start button
    end
    
    result = nil
    return result
  end
  
  def initLoginWidget
    @loginWidget = Gtk::VBox.new
    @usernameEntry = Gtk::Entry.new
    @loginWidget.pack_start GtkHelper.createBox('H', 
      [ { :type => Gtk::Label, :content => "Username: " },
        { :widget => @usernameEntry } ] )
    @passwordEntry = Gtk::Entry.new
    @loginWidget.pack_start GtkHelper.createBox('H', 
      [ { :type => Gtk::Label, :content => "Password: " },
        { :widget => @passwordEntry } ] )
    loginButton = Gtk::Button.new "Login"
    GtkHelper.applyEventHandler(loginButton, :clicked) {
      begin
        @controller.login(@usernameEntry.text, @passwordEntry.text)
        switchContext :account
      rescue Exception => e
        updateLoginWidget "Login Failed"
        @window.show_all
      end
    }
    createAccountButton = Gtk::Button.new "Create Account"
    GtkHelper.applyEventHandler(createAccountButton, :clicked) {
      begin
        @controller.createAccount(@usernameEntry.text, @passwordEntry.text)
        switchContext :account
      rescue Exception => e
        updateLoginWidget "Account Creation Failed"
        @window.show_all
      end
    }
    @loginWidget.pack_start GtkHelper.createBox('H', 
      [ { :widget => loginButton },
        { :widget => createAccountButton } ] )
    @loginResult = Gtk::Label.new ""
    @loginWidget.pack_start @loginResult
  end
  
  def updateLoginWidget(message)
    @loginResult.text = message
  end
  
  def initLogoutWidget
    @logoutWidget = Gtk::VBox.new
    @loggedInMessage = Gtk::Label.new "Logged in as [username]"
    button = Gtk::Button.new "Log out"
    GtkHelper.applyEventHandler(button, :clicked) {@controller.logout}
    @logoutWidget.pack_start @loggedInMessage
    @logoutWidget.pack_start button
  end
  
  def updateLogoutWidget
    #Called when newly logged in
    @loggedInMessage.text = "Logged in as " + @controller.clientSettings.username
  end
  
  def initServerWidget
    @serverWidget = Gtk::VBox.new
    @addressEntry = Gtk::Entry.new
    @addressEntry.text = @controller.clientSettings.host + ":" + @controller.clientSettings.port.to_s
    @serverWidget.pack_start GtkHelper.createBox('H', 
      [ { :type => Gtk::Label, :content => "Server Address: " },
        { :widget => @addressEntry } ] )
    connectButton = Gtk::Button.new "Connect"
    GtkHelper.applyEventHandler(connectButton, :clicked) {
      if @addressEntry.text.length > 0
        add = @addressEntry.text.split(':')
        if add.size > 1
          host = add[0]
          port = add[1]
          @controller.clientSettings.host = host
          @controller.clientSettings.port = Integer(port)
          @controller.clientSettings.save 
        end
      end
      if @controller.testConnection
        updateServerWidget "Connection successful"
      else
        updateServerWidget "Connection failed"
      end
      @window.show_all
    }
    @serverWidget.pack_start connectButton
    @serverConnectionResult = Gtk::Label.new ""
    @serverWidget.pack_start @serverConnectionResult
  end
  
  def updateServerWidget(message)
    #Update serverConnectionResult based on how the server connected
    @serverConnectionResult.text = message
  end
  
  def initStatsWidget
    @statsWidget = Gtk::ScrolledWindow.new
    vbox = Gtk::VBox.new
    vbox.pack_start Gtk::Label.new "Top Player Stats:"
    @topPlayerStatsWidget = Gtk::Label.new "[database stats go here]"
    vbox.pack_start @topPlayerStatsWidget
    vbox.pack_start Gtk::Label.new "Your Stats:"
    @yourStatsWidget = Gtk::Label.new "[player stats go here]"
    vbox.pack_start @yourStatsWidget
    @statsWidget.add_with_viewport vbox
    @statsWidget.set_size_request(400,200)
  end
  
  def updateStatsWidget
    begin
      @topPlayerStatsWidget.text = ""
      @controller.getTopStatistics.each do |stat|
        @topPlayerStatsWidget.text += stat.to_s + "\n"
      end
      if @controller.clientSettings.sessionId.length >= 1
        @yourStatsWidget.text = @controller.getMyStatistics.to_s
      end
    rescue
      @topPlayerStatsWidget.text = "Connect to a server to see top player stats."
      @yourStatsWidget.text = "Log in or sign up to see your stats."
    end
  end
end