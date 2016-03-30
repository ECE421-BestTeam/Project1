require_relative '../client/client'

module ServerContract
  
  def class_invariant

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
  
  def post_getRequest(req)
    reqs = ["closeConnection","createPlayer","login","logout","getStats","getGames","newGame","joinGame","placeToken","saveRequest","saveResponse","forfeit","getGame"]
    assert req.class == String && reqs.include?(req), "request must be a valid String"
  end
  
  def pre_buildResponse(status, data)
    assert status.class == Symbol and [:ok, :failed].include?(status), "status is an invalid Symbol"
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
