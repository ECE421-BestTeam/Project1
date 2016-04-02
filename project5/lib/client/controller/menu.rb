require_relative './contract-menu'
require_relative './menu-default'
require_relative './board'

# menu/settings controller interface
class MenuController
  include MenuControllerContract
  
  #initializes the menu controller
  def initialize(settings = SettingsModel.new)
    pre_initialize(settings)
    
    @settings = settings
    
    post_initialize
    class_invariant
  end
  
  # called after a user has completed all settings
  # returns GameModel successful
  def getBoardController
    pre_getBoardController
    
    result = BoardController.new(@settings)

    post_getBoardController(result)
    class_invariant
    return result
  end
  
  def settings
    pre_settings
    
    result = @settings
    
    post_settings(result)
    class_invariant
    return result
  end
  
  $settings = [
    :players, # players - number of players
    :victoryType, # victoryType - number: 0 = normal, 1 = OTTO
    :boardControllerType, # the board controller type: 0 = local
    :rows, # rows - number of rows in board
    :cols # cols - number of cols in board
  ]  

  # Creates a getter and setter for each setting
  $settings.each do |setting|
    
    #create getter
    define_method("#{setting}") do |*args, &block|
      result = @settings.method("#{setting}").call
      class_invariant
      return result
    end
    
    #create setter
    define_method("#{setting}=") do |*args, &block|
      val = args[0]
      @settings.method("#{setting}=").call(val)
      class_invariant
    end
    
  end
  
end