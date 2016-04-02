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
        
    initMenu
    loop
  end
  
  def initMenu
    trap("SIGINT") do
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
      end
    end
  end
  
  # attempts to start game
  def startGame
    # sends options and create a custom boardController
    bController = @controller.getBoardController
    
    # start a board view
    BoardView.new(@boardViewType, bController) do |model|
      # exit game callback
      puts "\n"
      @mode = :options
      initMenu
    end
  end
  
  # queries the user for their desired options
  def getOptions
    @gameSettings = GameSettingsModel.new
    temp = nil
    
    puts "Type 'exit' at any time to exit"
    puts "--OPTIONS--"
    @helper.getUserInput(
      "0 = Practice, 1 = Compete, 2 = Statistics", 
      ['0', '1', '2'], 
      Proc.new { |res| temp = res })
    case temp
      when '0'
        gameSettings.mode = :practice
        getPracticeOptions
      when '1'
        gameSettings.mode = :compete
        getCompeteOptions
      when '2'
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
            @mode = :options
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
            res = :victoryNormal
          when 1
            res = :victoryOtto
        end
        @gameSettigs = res
      })
  end
  
  def getPracticeOptions
    @helper.getUserInput(
      "How many players? (1 or 2)", 
      [1, 2], 
      Proc.new { |res| @controller.players = res})
    getVictoryType
  end
  
  
  def getCompeteOptions
    while !@controller.testServer
      @helper.getUserInput(
        "Server at #{@controller.clientSettings.serverAddress} not responding. Enter a new serverAddress.", 
        [//],
        Proc.new { |res| @controller.clientSettings.serverAddress = res if res.length > 0})
    end
    
  end
  
end
