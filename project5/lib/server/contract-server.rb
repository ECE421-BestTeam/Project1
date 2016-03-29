module ServerContract
  
  def class_invariant
    assert @port.class == Fixnum, "server must have a port number"
    assert @db, "Database must exist"
    assert @server, "server object must exist"
  end
  
  def pre_initialize(port, timeout)
    assert port.class == Fixnum, "port must be initalized as a Fixnum"
    assert timeout.class == Float, "timeout must be initalized as a Float"
    
  end

  def post_initialize
    
  end
  
  def pre_getRequest(client)
    assert client.class == Client, "invalid client"
  end
  
  def post_getRequest
  
  end
  
  def pre_buildResponse(status, data)
    assert status.class == Symbol and [:ok, :fail].include?(status), "status is an invalid Symbol"
    assert data.class == String, "data must be a String"
  end
  
  def post_buildResponse
    
  end
  
  def pre_createPlayer(client)
    assert client.class == Client, "invalid client"
  end
  
  def post_createPlayer
    
  end
  
  def pre_login(client)
    assert client.class == Client, "invalid client"
  end
  
  def post_login    

  end

  def pre_logout(client)
    assert client.class == Client, "invalid client"
  end
  
  def post_logout    

  end

  def pre_getStats(client)
    assert client.class == Client, "invalid client"
  end
  
  def post_getStats    
    assert client.class == Client, "invalid client"
  end

  def pre_getGames(client)
    assert client.class == Client, "invalid client"
  end
  
  def post_getGames    

  end

  def pre_newGame(client)
    assert client.class == Client, "invalid client"
  end
  
  def post_newGame    

  end

  def pre_joinGame(client)
    assert client.class == Client, "invalid client"
  end
  
  def post_joinGame(result)
    assert result.class == String, "result must be a valid address of type String"

  end

  def pre_placeToken(client)
    assert client.class == Client, "invalid client"
  end
  
  def post_placeToken    

  end

  def pre_saveRequest(client)
    assert client.class == Client, "invalid client"
  end
  
  def post_saveRequest    

  end

  def pre_saveResponse(client)
    assert client.class == Client, "invalid client"
  end
  
  def post_saveResponse    

  end

  def pre_forfeit(client)
    assert client.class == Client, "invalid client"
  end
  
  def post_forfeit    

  end

  def pre_getGame(client)
    assert client.class == Client, "invalid client"
  end
  
  def post_getGame(result)
    assert result.class == GameModel

  end
  
end
