require_relative './board'
require_relative '../controller/menu'

# should not contain any logic as it is the view
class MenuCmd
  
  # creates the board and sets the listeners
  def initialize(boardViewType, menuControllerType)
    @boardViewType = boardViewType
    
    # the menu options
    @controller = MenuController.new menuControllerType
    
    getOptions
  end
  
  # attempts to start game
  def startGame
    # sends options and create a custom boardController
    bController = @controller.getBoardController
    
    # start a board view
    BoardView.new(@boardViewType, bController) do |model|
      # exit game callback
      puts 'Welcome back'
      getOptions
    end
  end
  
  # queries the user for their desired options
  def getOptions
    
    getOption(
      "How many players? (1 or 2)", 
      [1, 2], 
      Proc.new { |res| @controller.players = res})
    getOption(
      "What game mode would you like? (0 = Normal, 1 = OTTO)", 
      [0, 1], 
      Proc.new { |res| @controller.victoryType = res})
    
    getOption(
      "We're done.  (0 = Start game, 1 = Restart menu options)", 
      [0, 1], 
      Proc.new do |res| 
        case res
          when 0
            startGame
          when 1
            getOptions
        end
        
      end
    )

  end
  
  # question - string that is printed
  # answers - an array of valid answers
  # callback - called with a valid answer
  # recursive - boolean used to indicate if this is a recursive call
  def getOption(question, answers, callback, recursive = false)
    puts question
    ans = gets
    
    # only wrap the callback on the first call
    if !recursive
      ocb = callback
      callback = Proc.new do |res|
        begin
          ocb.call(res)
        rescue Exception => e
          errorHandler(e)
          getOption(question, answers, callback, true)
        end
      end
    end
    
    if answers.include?(ans)
      callback.call(ans)
    elsif is_integer?(ans) && answers.include?(Integer(ans))
      callback.call(Integer(ans))
    else
      puts "Invalid response.  Should be one of: #{answers}"
      getOption(question, answers, callback, true)
    end
  end
  
  def errorHandler(err)
    puts err.to_s
  end
  
  def is_integer?(n)
    true if Integer(n) rescue false
  end
  
end