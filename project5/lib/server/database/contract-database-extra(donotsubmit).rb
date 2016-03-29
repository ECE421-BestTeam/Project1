require 'test/unit/assertions'

module DatabaseContract
  
  def class_invariant
  end
 
  def pre_initialize(type, settings)
    # type should be a symbol, :local or :mysql
    assert type.class == Symbol, "type must be initalized as a Symbol"
    # settings should be a hash with contents dependant on the type
    assert settings.class == Hash, "settings must be of type Hash"
    # :local - nothing required
    if type == :mysql
      assert setting.has_key?(:host) && setting(:host).class == String, "host must be of type String"
      assert setting.has_key?(:password) && setting(:password).class == String, "password must be of type String"
      assert setting.has_key?(:db) && setting(:db).class == Mysql, "db must be of type Mysql"
      assert setting.has_key?(:port) && setting(:port).class == Fixnum, "port must be of type Fixnum"
    end
    # :mysql - host, username, password, db, port  (all string, except port => fixnum)
  end
  
  def post_initialize
    
  end
  
  def pre_addStat(playerId, wins, losses, draws, gameId)
    assert playerId.class == String, "playerId must be a String"
    assert wins.class == Fixnum, "wins must be a Fixnum"
    assert losses.class == Fixnum, "losses must be a Fixnum"
    assert draws.class == Fixnum, "draws must be a Fixnum"
    assert gameId.class == String, "gameId must be a String"
  end
  
  def post_addStat
    # Stat is added to database
  end
  
  def pre_removeStat(playerId)
    # delete from stats where playerID = playerId
    assert playerId.class == String, "playerId must be a String"
  end
  
  def post_removeStat
  end
  
  def getStat(playerId)
    assert playerId.class == String, "playerId must be a String"
  end
  
  def pre_getGame(gameID)
    assert gameID.class == String, "gameID must be a String"
  end
  
  def post_getGame(gameID)
    assert gameID.class == String, "returning gameID must be a String"
  end
  
  def checkOut(gameTable, gameID, &checkoutfn)
  end
end