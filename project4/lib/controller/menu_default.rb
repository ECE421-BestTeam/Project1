require_relative '../model/settings'

# menu/settings controller interface
class MenuDefaultController
  
  attr_reader :settings
  
  #initializes the selected board controller
  def initialize (settings = SettingsModel.new)
    @settings = settings
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
      @settings.method("#{setting}").call
    end
    
    #create setter
    define_method("#{setting}=") do |*args, &block|
      @settings.method("#{setting}=").call(args[0])
    end
    
  end
  
end