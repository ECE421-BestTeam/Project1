require_relative './helper'
require_relative './board'
require_relative '../../controller/menu'

# should not contain any logic as it is the view
class CmdView
  
  # creates the board and sets the listeners
  def initialize
    
    # the menu options
    @controller = MenuController.new
    
    @helper = CmdHelper.new(Proc.new {exitMenu})
        
    setTrap
    
    @mode = :options #can be :options, :startGame, :inGame
    loop
  end
  
  def setTrap
    trap("SIGINT") do
      close
      puts "\nAbortted"
      exitMenu
    end
  end
  
  def exitMenu
    exit
  end
  
  def loop
    while true
      case @mode
        when :options
          getOptions
        when :startGame
          startGame
        when :inGame #let other stuff do stuff
          sleep 0.5
      end
    end
  end
  
  # attempts to start game
  def startGame
    @mode = :inGame
    # sends options and create a custom boardController
    @bController = @controller.getBoardController(@boardControllerType, @gameSettings)
    
    # start a board view
    ViewCmdBoard.new(
      @bController, 
      Proc.new do |model|
        # exit game callback
        puts "\nFinished Game!"
        setTrap
        @mode = :options
      end
    )
  end
  
  # queries the user for their desired options
  def getOptions
    @gameSettings = GameSettingsModel.new
    temp = nil
    
    puts "Type 'exit' at any time to exit"
    puts "--OPTIONS--"
    @helper.getUserInput(
      "0 = Practice, 1 = Compete, 2 = Statistics", 
      [0, 1, 2], 
      Proc.new { |res| temp = res })
    case temp
      when 0
        @boardControllerType = 'local'
        getPracticeOptions
      when 1
        @boardControllerType = 'online'
        getCompeteOptions
      when 2
        showStatistics
        return
    end

    @helper.getUserInput(
      "We're done.  (0 = Start game, 1 = Restart menu options)", 
      [0, 1], 
      Proc.new do |res| 
        case res
          when 0
            @mode = :startGame
          when 1
            # do nothing, let options loop
        end

      end
    )
  end
  
  def getVictoryType
    @helper.getUserInput(
      "What game mode would you like? (0 = Normal, 1 = OTTO)", 
      [0, 1], 
      Proc.new { |res| 
        case res
          when 0
            res = 'victoryNormal'
          when 1
            res = 'victoryOtto'
        end
        @gameSettings.victoryType = res
      })
  end
  
  def getPracticeOptions
    @helper.getUserInput(
      "How many players? (1 or 2)", 
      [1, 2], 
      Proc.new { |res| @gameSettings.players = res})
    getVictoryType
  end
  
  def connect
    # get server address if current one is invalid
    while !@controller.testConnection
      @helper.getUserInput(
        "Server at #{@controller.clientSettings.host}:#{@controller.clientSettings.port} not responding. Enter a new serverAddress:", 
        [/.*:[0-9]*$/],
        Proc.new { |res| 
          if res.length > 0
            add = res.split(':')
            host = add[0]
            port = add[1]
            @controller.clientSettings.host = host
            @controller.clientSettings.port = Integer(port)
            @controller.clientSettings.save 
          end
        })
    end
        
    # get user to login
    @helper.getUserInput(
      "0 = Login, or 1 = Create Account", 
      [0, 1],
      Proc.new { |res| 
        case res
          when 0
            login
          when 1
            createAccount
        end
      })
    
  end
  
  def close
    @bController.close if @bController
    @controller.close
  end
  
  def getCompeteOptions
    connect
    
    # Let the user choose the game to play
    games = @controller.getGames
    selectedGame = nil
    while !selectedGame
      @helper.getUserInput(
        "0 = New Game, 1 = Active Games(#{games['active'].size}), 2 = Saved Games(#{games['saved'].size}), 3 = Join Game(#{games['joinable'].size})", 
        [0, 1, 2, 3],
        Proc.new { |res| 
          case res
            when 0
              getVictoryType
              selectedGame = @gameSettings
            when 1
              selectedGame = showGameList("Active Games", games['active'])
            when 2
              selectedGame = showGameList("Saved Games", games['saved'])
            when 3
              selectedGame = showGameList("Joinable Games", games['joinable'])
          end
        })
    end
    
    @gameSettings = selectedGame
  end
  
  def login
    while true
      creds = getCreds
      begin
        @controller.login(creds[0], creds[1])
        break
      rescue Exception => e
        puts "Login Failed.  Try again."
        puts e 
      end
    end
  end
  
  def createAccount
    while true
      puts 'Please enter a new username and password.'
      creds = getCreds
      begin
        @controller.createAccount(creds[0], creds[1])
        break
      rescue Exception => e
        puts "Account creation Failed.  Try again."
        msg = e.message
        e.backtrace.each do |level|
          msg += "\n\t#{level}"
        end
        puts msg
      end
    end
  end
  
  def getCreds
    result = ['', '']
    @helper.getUserInput(
      "Username:", 
      [/^.*$/],
      Proc.new { |res| 
        result[0] = res
      })
    @helper.getUserInput(
      "Password:", 
      [/^.*$/],
      Proc.new { |res| 
        result[1] = res
      })
    return result
  end
  
  def showGameList(title, games)
    text = "--- #{title} ---\n"
    answers = ['back']
    games.each_with_index do |gameEntry, i|
      game = gameEntry['game_model']
      text += "#{i} = Victory Mode: #{game.victory.name}, Turn: #{game.turn}\n"
      answers.push(i)
    end
    text += "Please select a game, or enter 'back' to return."
    
    result = nil
    @helper.getUserInput(
      text, 
      answers,
      Proc.new { |res| result = games[res]['game_id'] if res != 'back' })
    return result
  end
  
  def showStatistics
    connect
    topStats = @controller.getTopStatistics
    myStats = @controller.getMyStatistics
    puts "\n-=Top Player Stats=-"
    topStats.each do |stat|
      displayStat(stat)
    end
    puts "\n-=My Stats=-"
    displayStat(myStats.to_s)
    @helper.getUserInput(
      "\nENTER to continue", 
      [//],
      Proc.new { |res| }
    )
  end
  
  def displayStat(stat)
    puts stat.to_s
  end
  
  def handleSaveRequest
    puts "save in view"
  end
  
end