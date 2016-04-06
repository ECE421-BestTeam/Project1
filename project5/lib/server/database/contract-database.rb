require 'test/unit/assertions'

module DatabaseContract
  include Test::Unit::Assertions
  
  def class_invariant
    assert @db.class == Mysql, "db must be a Myql database"
  end
 
  def pre_initialize
  end
  
  def post_initialize
  end
  
  def pre_addStats(playerId, wins, losses, draws)
    assert playerId.class == String, "playerId must be a String"
    assert wins.class == Fixnum, "wins must be a Fixnum"
    assert losses.class == Fixnum, "losses must be a Fixnum"
    assert draws.class == Fixnum, "draws must be a Fixnum"
  end
  
  def post_addStats
    # Stat is added to database
  end
  
  def pre_updateStat (playerId, stat, delta)
    assert playerId.class == String, "playerId must be a String"
    assert stat.class == String && ["wins", "losses", "draws"].include?(stat), "stat must be a String and be wins losses or draws"
    assert delta.class == Fixnum, "delta must be an integer"
  end
  
  def post_updateStat
  end
  
  def pre_getStats(playerId)
    assert playerId.class == String, "playerId must be a String"
  end
  
  def post_getStats(result)
    assert result.class == Hash || result==nil, "result must be a db record in Hash format or nil"
  end
  
  def pre_addGame(gameId, player1Id, player2Id, playerTurn, gameBoard, state)
    assert gameId.class == String, "gameId must be a String"
    assert player1Id.class == String || player1Id==nil, "player1Id must be a String or nil"
    assert player2Id.class == String || player2Id==nil, "player2Id must be a String or nil"
    assert (playerTurn == Fixnum  && playerTurn.between?(1,2)) || playerTurn==nil, "playerTurn must be a Fixnum of either 1 or 2, or nil"
    assert gameBoard.class == Array && gameBoard[0].class == Array, "gameBoard must be an array of arrays"
    assert state.class == String && ["active", "saved"].include?(state), "state must be a String, either active or saved"
  end
  
  def post_addGame
  end
  
  def pre_updateGame(gameId, field, value)
    assert gameId.class == String, "gameID must be a String"
    assert field.class == String && ['player1id', 'player2id', 'playerturn', 'gameboard', 'state'].include?(field.downcase), "must be a valid field in the games table"
    # value types are protected by database
  end
  
  def post_updateGame
  end
  
  def pre_getGame(gameId)
    assert gameId.class == String, "gameId must be a String"
  end
  
  def post_getGame(result)
    assert result.class == Hash, "getGame must return a Hash object"
  end
  
  def pre_getPlayerGames(playerId)
    assert playerId.class == String, "playerId must be a String"
  end
  
  def post_getPlayerGame(result)
    assert result.class == Array && result[0].class == Hash, "getGame must return an array of Hashes"
  end
  
  def pre_checklogin(username, password)
    assert username.class == String, "username must be a String"
    assert password.class == String, "password must be a String"
  end
  
  def post_checkLogin(result)
    assert result == true || result == false, "login result must be true or false"
  end
  
end