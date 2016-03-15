require_relative './contract-settings'

# A model for the settings for the connect four game
class SettingsModel
  include SettingsContract
  
  # initializes the settings
  def initialize(players = 1, victoryType = 0, boardControllerType = 0, rows = 6, cols = 7)
    
    @players = players
    @victoryType = victoryType
    @boardControllerType = boardControllerType
    @rows = rows
    @cols = cols
    
  end
  
  $attributes = [
    :players, # players - number of players
    :victoryType, # victoryType - number: 0 = normal, 1 = OTTO
    :boardControllerType, # the board controller type: 0 = local
    :rows, # rows - number of rows in board
    :cols # cols - number of cols in board
  ]  

  # Creates a getter and setter for each attribute
  $attributes.each do |attribute|
    
    #create getter
    define_method("#{attribute}") do |*args, &block|
      result = instance_variable_get("@#{attribute}")
      class_invariant
      return result
    end
    
    #create setter
    define_method("#{attribute}=") do |*args, &block|
      val = args[0]
      self.method("pre_#{attribute}=").call(val)
      
      result = instance_variable_set("@#{attribute}", val)
      
      class_invariant
      return result
    end
    
  end
  
end
