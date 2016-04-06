require 'test/unit'
require_relative '../../lib/server/database'

class ServerTest < Test::Unit::TestCase
  
  # not an extensive test for validity
  # used for debugging sql queries, mostly
  def setup
    @db = Database.new
    @user = "user1"
    @pswd = "pswd"
    @server - "serveraddress1"
    @session
    @game = "somegame"
    @gameId
    
  end

  def teardown
  end
  
  def test_registerServer
    assert @db.registerServer(@server).is_a? String
  end
  
  def test_getLeastActiveServer
    assert @db.getLeastActiveServer.is_a? String
  end


  def test_getServerGames
    assert @db.getServerGames(@server).is_a? Array
  end
  
  def test_createPlayer
    assert @db.createPlayer(@user, @pswd).is_a? String
  end
  
  def test_checkLogin
    @session = @db.checkLogin(@user, @pswd)
    assert @session.is_a? String
  end
  
  def test_newGame
    @gameId= @db.newGame(@session, @game)
    assert @gameId.is_a? String
  end
  
  def test_joinGame
    othersession = @db.createPlayer("otherplayer", "otherpswd")
    othergameId = @db.newGame(othersession, "othergame")
    assert @db.joinGame(@session, othergameId).is_a? String
  end
  
  def test_getGame
    assert @db.getGame(@gameId).is_a? Hash
  end
  
  def test_updateGame
    @db.updateGame(@gameId, "state", "saved")
  end
  
  def test_getMyStats
    assert @db.getMyStats(@session).is_a? Hash
  end
  
  def test_getTopStats
    assert @db.getTopStats.is_a? Array
    assert @db.getTopStats(2).is_a? Array
  end
  
  def test_getPlayer
    assert @db.getPlayerID(@session).is_a? String
  end
  
  def test_getPlayerGames
    assert @db.getPlayerGames(@session).is_a? Array
  end
  
  def test_logout
    assert @db.logout(@session).is_a? String
  end
  
  
end