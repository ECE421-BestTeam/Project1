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
    
    @mode = :options #can be :wait, :options, :startGame
    loop
  end
  
  # attempts to start game
  def startGame
    @mode = :wait
    # sends options and create a custom boardController
    bController = @controller.getBoardController
    
    # start a board view
    BoardView.new(@boardViewType, bController) do |model|
      # exit game callback
      puts 'Welcome back'
      @mode = :options
    end
  end
  
  def loop
    while true
      case @mode
        when :wait
          sleep 0 # don't do anything until our mode is changed
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
    CmdHelper.getUserInput(
      "How many players? (1 or 2)", 
      [1, 2], 
      Proc.new { |res| @controller.players = res})
    CmdHelper.getUserInput(
      "What game mode would you like? (0 = Normal, 1 = OTTO)", 
      [0, 1], 
      Proc.new { |res| @controller.victoryType = res})

    CmdHelper.getUserInput(
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