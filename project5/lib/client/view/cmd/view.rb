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
    @mode = :options #can be :options, :startGame
        
    setTrap
    
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
      getOptions
    end
  end
  
  # attempts to start game
  def startGame
#    @mode = :playingGame
    
    # sends options and create a custom boardController
    @bController = @controller.getBoardController(@boardControllerType, @gameSettings)
    
    # start a board view
    ViewCmdBoard.new(
      @bController, 
      Proc.new do |model|
        # exit game callback
        puts "\n"
        setTrap
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
            startGame
          when 1
            return
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
    while !@controller.connect
      @helper.getUserInput(
        "Server at #{@controller.clientSettings.serverAddress} not responding. Enter a new serverAddress.", 
        [//],
        Proc.new { |res| 
          if res.length > 0
            @controller.clientSettings.serverAddress = res
            @controller.clientSettings.save
          end
        })
    end
  end
  
  def close
    @bController.close
    @controller.close
  end
  
  def getCompeteOptions
    connect
    # get user to login
    @helper.getUserInput(
      "0 = Login, or 1 = Create Account", 
      [0, 1],
      Proc.new { |res| 
        case
          when 0
            login
          when 1
            createPlayer
        end
      })
    
    # Let the user choose the game to play
    games = @controller.getGames
    selectedGame = nil
    while !selectedGame
      @helper.getUserInput(
        "0 = New Game, 1 = Active Games(#{games['active'].size}), 2 = Saved Games(#{games['saved'].size}), 3 = Join Game(#{games['joinable'].size})", 
        [0, 1, 2, 3],
        Proc.new { |res| 
          case
            when 0
              getVictoryType
              selectedGame = nil
              break
            when 1
              selectedGame = showGameList("Active Games", games['active'])
            when 2
              selectedGame = showGameList("Saved Games", games['saved'])
            when 3
              selectedGame = showGameList("Joinable Games", games['joinable'])
          end
        })
    end
    
    @gameSettings = selectedGame.id if selectedGame
  end
  
  def login
    while true
      creds = getCreds
      begin
        @controller.login(creds[0], creds[1])
        break
      rescue Exception => e
        puts "Login Failed.  Try again. #{e}"
      end
    end
  end
  
  def createAccount
    while true
      creds = getCreds
      begin
        @controller.createAccount(creds[0], creds[1])
        break
      rescue Exception => e
        puts "Account creation Failed.  Try again. #{e}"
      end
    end
  end
  
  def getCreds
    result = ['', '']
    @helper.getUserInput(
      "Username:", 
      [//],
      Proc.new { |res| result[0] = res})
    @helper.getUserInput(
      "Password:", 
      [//],
      Proc.new { |res| result[1] = res})
    return result
  end
  
  def showGameList(title, games)
    text = "--- #{title} ---\n"
    answers = ['back']
    games.each_with_index do |game, i|
      text += "#{i} = #{game.victoryType} Turn: #{game.turn}\n"
      answers.push(i)
    end
    text += "Please select a game, or enter 'back' to return."
    
    result = nil
    @helper.getUserInput(
      text, 
      answers,
      Proc.new { |res| result = games[res] if res != 'back' })
    return result
  end
  
  def showStatistics
    connect
    stats = @controller.getTopStatistics
    puts stats.to_s
  end
  
end