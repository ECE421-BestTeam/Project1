require 'test/unit/assertions'
require_relative '../../common/model/game'

module DatabaseContract
  include Test::Unit::Assertions
  
  def class_invariant
    assert @db.class == Mysql2::Client, "db must be a Mysql2 database"
  end

  
  ####
  
  def pre_initialize
  end
  
  def post_initialize
  end

  
  ####
  
  def pre_registerServer(serverAddress)
    assert serverAddress.class == String, "serverAddress must be a String"
  end

  
  def post_registerServer(game_ids)
    assert game_ids.class == Array, "game_ids must be an Array"
    # implies the game_ids must be length >=1
  end

  ####
  
  def pre_setServerData(serverAddress, data)
    assert serverAddress.class ==  String, "serverAddress must be a string"
    assert data.class==  Hash, "data must be a Hash type"
  end
  
  def post_setServerData
    
  end
  ####
  
  def pre_getServerData(serverAddress)
    assert serverAddress.class == String, "serverAddress must be a string"
  end
  
  def post_getServerData(result)
    assert result.class ==  Hash, "returned data must be a hash"
  end
  ###

  def pre_getLeastActiveServer
  end
  
  def post_getLeastActiveServer(server_address)
    assert server_address.class == String, "return server_address must be a string"
  end
  
  ####
  
  def pre_getServerGames(server_address)
    assert server_address.class == String, "server_address must be a String"
  end
  
  def post_getServerGames(gameids)
    assert gameids.class == Array, "gameids must be an Array"
  end
  ####
  
  def pre_createPlayer(username, password)
    assert username.class == String, "username must be a String"
    assert password.class == String, "password must be a String"
  end
  
  def post_createPlayer(sess_id)
    assert sess_id.class == String, "sess_id must be a String"
  end
  
  ####
  
  def pre_checklogin(username, password)
    assert username.class == String, "username must be a String"
    assert password.class == String, "password must be a String"
  end
  
  def post_checkLogin(result)
    assert result.class == String, "login sessID must be String"
  end
  
  ####
  
  def pre_logout(sessionId)
    assert sessionId.class == String, "sessionId must be a String"
  end
  
  def post_logout
  end
  
  ####
  
  def pre_getPlayerGames(sessionId)
    assert sessionId.class == String, "sessionId must be a String"
  end
  
  def post_getPlayerGames(result)
    assert result.class == Array, "getPlayerGames must return an array"
    if !result.empty?
      assert result[0].class == Hash, "result array must contain Hash types"
    end
  end
  
  ####
  
  def pre_newGame(sessionId, game)
    assert sessionId.class == String, "sessionId must be a String"
    assert game.class == GameModel, "game must be a valid GameModel (unserialized)"
  end
  
  def post_newGame(gameId)
    assert gameId.class == String, "returned gameId must be a String"
  end
  
  ####
  
  def pre_joinGame(sessionId, gameId)
    assert sessionId.class == String, "sessionId must be a String"
    assert gameId.class == String, "gameId must be a String"

  end
  
  def post_joinGame(game)
    assert game.class == Hash, "returned game from joinGame must be a Hash"
  end
  
  ####
  
  def pre_getGame(gameId)
    assert gameId.class == String, "gameId must be a String"
  end
  
  def post_getGame(result)
    assert result.class == Hash, "game result must be a hash"
  end
  
  ####
  
  def pre_updateGame(gameId, field, value)
    assert gameId.class == String, "gameID must be a String"
    assert field.class == String && ['player1id', 'player2id', 'playerturn', 'gameboard', 'state'].include?(field.downcase), "must be a valid field in the games table"
    # value types are protected by database
  end
  
  def post_updateGame
  end
  
  ####
  
  def pre_updateStat (sessionId, stat, delta)
    assert sessionId.class == String, "sessionId must be a String"
    assert stat.class == String && ["wins", "losses", "draws"].include?(stat), "stat must be a String and be wins losses or draws"
    assert delta.class == Fixnum, "delta must be an integer"
  end
  
  def post_updateStat
  end
  
  ####
  
  def pre_getMyStats(sessionId)
    assert sessionId.class == String, "playerId must be a String"
  end
  
  def post_getMyStats(result)
    assert result.class == Hash, "result must be a db record in Hash format"
  end
  
  ####
  
  def pre_getTopStats(num)
    assert num.class == Fixnum, "num must be a Fixnum"
  end
  
  def post_getTopStats(results)
    assert results.class == Array, "top stats results must be an Array"
    if !results.empty?
      assert results[0].class == Hash, "results Array must contain Hash types"
    end
  end
  
  ####
  
  def pre_getPlayerID(sessionId)
    assert sessionId.class == String, "sessionId must be a String"
  end
  
  def post_getPlayerID(playerId)
    assert playerId.class == String, "playerId must be a String"
  end
  
end