require 'test/unit'
require_relative '../../lib/server/database/database'
require_relative '../../lib/common/model/game'


class ServerTest < Test::Unit::TestCase
  include
  
  # not an extensive test for validity
  # used for debugging sql queries, mostly
  # mysql -u us -p -h 142.179.143.183 -P 3306 (with our secret password)
  # reload empty tables using 'source load-tables.sql'
  # then run this testfile
  def setup
    @db = Database.new
#    @user = "user1"
#    @pswd = "pswd"
#    @server = "serveraddress1"
#    @session = "session"
#    @game = GameModel.new(GameSettingsModel.new)
#    @gameId = "gameid"

  end

  def teardown
  end
  
  def test_registerServer
    assert @db.registerServer("server1").is_a? Array
  end
  
  def test_getLeastActiveServer
    assert @db.getLeastActiveServer.is_a? String
  end


  def test_getServerGames
    @db.registerServer("server2")
    assert @db.getServerGames("server2").is_a? Array
  end

  def test_createPlayer
    assert @db.createPlayer("user1", "pswd1").is_a? String
  end
  
  def test_checkLogin
    @db.createPlayer("newUser", "newpswd")
    session = @db.checkLogin("newUser", "newpswd")
    assert session.is_a? String
  end

  def test_newGame
    @db.registerServer("newServer")
    game = GameModel.new(GameSettingsModel.new)
    session = @db.createPlayer("user3", "pswd3")
    gameId= @db.newGame(session, game)
    assert gameId.is_a? String
  end
  
  def test_joinGame

    game = GameModel.new(GameSettingsModel.new)
    session = @db.createPlayer("joinplayer", "joinpswd")
    othergameId = @db.newGame(session, game)
    othersession = @db.createPlayer("otherplayer", "otherpswd")
    j = @db.joinGame(othersession, othergameId)
    assert j.is_a? Hash
    assert j['game_model'].is_a? GameModel
  end

  def test_getGame
    @db.registerServer("server1")
    game = GameModel.new(GameSettingsModel.new)
    session = @db.createPlayer("user4", "pswd4")
    gameId= @db.newGame(session, game)

    g = @db.getGame(gameId)
    assert g.is_a? Hash
    assert g['game_model'].is_a? GameModel
  end

  def test_updateGame
    game = GameModel.new(GameSettingsModel.new)
    session = @db.createPlayer("user5", "pswd5")
    gameId= @db.newGame(session, game)

  
    @db.updateGame(gameId, "state", "saved")
  end

  def test_getMyStats
    session = @db.createPlayer("user2", "pswd2")
    assert @db.getMyStats(session).is_a? Hash
  end

  def test_getTopStats
    assert @db.getTopStats.is_a? Array
    assert @db.getTopStats(2).is_a? Array
  end
#
#  def test_getPlayer
#    assert @db.getPlayerID(@session).is_a? String
#  end
#  
#  def test_getPlayerGames
#    assert @db.getPlayerGames(@session).is_a? Array
#  end
#  
#  def test_logout
#    assert @db.logout(@session).is_a? String
#  end

  
end