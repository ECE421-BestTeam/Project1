

module ClientContract
  
  def class_invariant

  end
  
  def pre_initialize(settings)
    #should be a hash with clientAddress
    assert settings.class == Hash && settings.has_key?(:clientAddress), "client settings must be a Hash and have clientAddress"
    
  end

  def post_initialize
    
  end
  
  # will automatically append user's identity token (if exists)
  # will automatically append game Id (if exists)
  def pre_sendRequest(req)
  
  end
  
  # should return the result of the request
  def post_sendRequest(result)
  
  end
  
  def pre_createPlayer(username, password)
    assert username.class == String, "username must be a String"
    assert password.class == String, "password must be a String"
    
  end
  
  def post_createPlayer(result)
    
  end
  
  def pre_login(username, password)
    assert username.class == String, "username must be a String"
    assert password.class == String, "password must be a String"
  end
  
  def post_login(result)

  end

  def pre_logout
    
  end
  
  def post_logout(result)

  end

  def pre_getStats
    
  end
  
  def post_getStats(result) 

  end

  def pre_getGames
    
  end
  
  def post_getGames(result)

  end

  def pre_newGame
    
  end
  
  def post_newGame(gameId)

  end

  def pre_joinGame(gameId)
    assert gameId.class == String, "gameId must be a String"
    
  end
  
  def post_joinGame

  end

  def pre_placeToken(col)
    assert col.class == String, "
  end
  
  def post_placeToken(result)  

  end

  def pre_saveRequest
    
  end
  
  def post_saveRequest(result)    

  end

  def pre_saveResponse(yes)
    #yes = true or false
    
  end
  
  def post_saveResponse(result)

  end

  def pre_forfeit
    
  end
  
  def post_forfeit(result)

  end

  def pre_getGame
    
  end
  
  def post_getGame(result) 

  end
  
end
