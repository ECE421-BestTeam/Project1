require 'xmlrpc/client'
require_relative './contract-game-settings'

# A model for the settings for the connect four game
class GameSettingsModel
  include XMLRPC::Marshallable
  include GameSettingsContract
  
  # initializes the settings
  def initialize(players = 2, victoryType = 'victoryNormal', mode = 'practice', rows = 6, cols = 7)
    
    @players = players
    @victoryType = victoryType
    @mode = mode
    @rows = rows
    @cols = cols
    
  end
  
  $attributes = [
    :players, # players - number of players
    :victoryType, # victoryType - number: 0 = normal, 1 = OTTO
    :mode, # :practice or :compete
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
