require_relative './contract-board'
require_relative './board-local'
require_relative './board-online'

# board controller interface
class BoardController
  include BoardControllerContract
  
  attr_reader :implementation
  
  #initializes the selected board controller
  def initialize (type, settings)
    pre_initialize(type, settings)
    
    case type
      when :boardControllerLocal
        @implementation = BoardLocalController.new settings
      when :boardControllerOnline
        @implementation = BoardOnlineController.new settings
    end
    
    post_initialize
    class_invariant
  end

  def settings
    pre_settings
    
    result = @implementation.settings
    
    post_settings(result)
    class_invariant
    return result
  end
  
  def localPlayers
    pre_localPlayers
    
    result = @implementation.localPlayers
  
    post_localPlayers(result)
    class_invariant
    return result
  end
  
  # registers the refresh command so the 
  # controller can call it when needed
  def registerRefresh(refresh)
    pre_registerRefresh(refresh)
    
    @implementation.registerRefresh(refresh)
    
    post_registerRefresh
    class_invariant
  end
  
  # called when closing the game
  def close 
    pre_close
    
    result = @implementation.close
    
    post_close
    class_invariant
    return result
  end
    
  # sends a request to place a token
  def placeToken(col)
    pre_placeToken(col)
    
    @implementation.placeToken(col)
    
    post_placeToken
    class_invariant
  end
  
end