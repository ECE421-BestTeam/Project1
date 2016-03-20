require_relative './cmd-helper'
require_relative './board'
require_relative '../controller/menu'

# should not contain any logic as it is the view
class MenuCmd
  
  # creates the board and sets the listeners
  def initialize(boardViewType, menuControllerType)
    @boardViewType = boardViewType
    
    # the menu options
    @controller = MenuController.new menuControllerType
    
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
  
  # queries the user for their desired options
  def getOptions
    puts "Type 'exit' at any time to exit"
    puts "--OPTIONS--"
    @helper.getUserInput(
      "How many players? (1 or 2)", 
      [1, 2], 
      Proc.new { |res| @controller.players = res})
    @helper.getUserInput(
      "What game mode would you like? (0 = Normal, 1 = OTTO)", 
      [0, 1], 
      Proc.new { |res| @controller.victoryType = res})

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
 
  
end