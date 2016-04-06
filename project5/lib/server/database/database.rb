require_relative './contract-database'
require 'mysql'
require 'securerandom'


class Database
  include DatabaseContract
  
  def initialize()
    pre_initialize
    
    begin
#      @db = Mysql.new("mysqlsrv.ece.ualberta.ca",
#      "ece421usr4",
#      "GKGul4FV",
#      "ece421grp4",
#      13010
#      )
      @db= Mysql.new("localhost", 'root', nil, 'ece421grp4', nil)
    rescue Mysql::Error => e
      puts e.error
    end
    
    post_initialize
#    class_invariant
  end
  
  def registerServer(serverAddress)
    # Adds serverAddress to server table and returns its game_ids
    # Returns: Array of Strings -- game_ids
    pre_registerServer(serverAddress)
    game_ids = [];
    begin
      @db.query("START TRANSACTION")
      @db.query("SELECT * FROM Server \
                  WHERE server_address='#{serverAddress}'" )
      if @db.affected_rows <= 0
        @db.query("INSERT INTO Server(server) VALUES('#{serverAddress}')")
      else
        game_ids = getServerGames(serverAddress)
      end
      @db.query("COMMIT")
    rescue Mysql::Error => e
      puts "DB ERROR: "+ e.error
    end
    post_registerServer(game_ids)
    return game_ids
  end
  
  def getLeastActiveServer
    # Gets the server address with the least amount of games assigned to it
    # Returns: String -- server_address
    pre_getLeastActiveServer
    # This one is a complicated query, not guaranteed to work
    begin
      res = @db.query("SELECT s.server_address as server_address, count(*) as num_games \
                  FROM Server s, Game g \
                  WHERE s.server_address=g.server_address\
                  GROUP BY s.server_address" )
    rescue Mysql::Error => e
      puts "DB ERROR: "+ e.error
    end
    server_address = res.fetch_hash['server_address']
    post_getLeastActiveServer(server_address)
    return server_address
  end
  
  def getServerGames(serverAddress)
    # Gets an a list of game_id associated with a serverAddress
    # Returns: Array of Strings -- game_id
    pre_getServerGames(serverAddress)
    result = []
    begin
      @db.query("START TRANSACTION")
      res = @db.query("SELECT g.game_id as game_id\
                  FROM Server s, Game g \
                  WHERE s.server_address=g.server_address")
      @db.query("COMMIT")
    rescue Mysql::Error => e
      puts "DB ERROR: "+ e.error
    end
    res.each_hash {|h|
      result << h['game_id']
    }
    post_getServerGames(result)
    return result
  end
  
  def createPlayer(username, password)
    # Adds a player to the Player table using playerId with 0s for stats
    # and assigns a new session ID (which is also added to Session table)
    # Returns: String -- sess_id
    pre_createPlayer(username, password)
    sess_id = newSessionID()
    begin
      @db.query("START TRANSACTION")
      @db.query("INSERT INTO Session(session_id) VALUES('#{sess_id}')")
      @db.query("INSERT INTO Player(username, password, points, wins, losses, draws, current_session_id) \
                  VALUES ( '#{username}', '#{password}',0, 0, 0, 0, '#{sess_id}')" )
      
      @db.query("COMMIT")
    rescue Mysql::Error => e
      puts "DB ERROR: "+ e.error
    end
    post_createPlayer(sess_id)
    return sess_id
  end
  
  def checkLogin(username, password)
    # Checks credentials against Player table
    # Updates player sessionID and Session table
    # Return Boolean -- true or false
    pre_checkLogin(username, password)
    result = ""
    begin
      @db.query("SELECT * from Player WHERE username='#{username}' and password='#{password}'")
      if @db.affected_rows == 1
        sess_id = newSessionID()
        @db.query("START TRANSACTION")
        @db.query("UPDATE Player \
                  SET current_session_id='#{sess_id}' \
                  WHERE username = '#{username}'")
        @db.query("DELETE FROM Session \
                    WHERE player_id='#{username}'")
        @db.query("INSERT INTO Session(session_id) VALUES('#{sess_id}'");
        @db.query("COMMIT")
        result = sess_id
      end
    rescue Mysql::Error => e
      puts "DB ERROR: "+e.error
    end
    post_checkLogin(result)
  end
  
  def logout(sessionId)
    # Remove sessionID from Player record
    # and Session table
    # Returns: --
    pre_logout(sessionId)
    begin
      @db.query("START TRANSACTION")
      @db.query("UPDATE Player \
                  SET current_session_id=NULL \
                  WHERE username = '#{username}'")
      @db.query("DELETE FROM Session WHERE session_id='#{sessionId}'")
      @db.query("COMMIT")
    rescue Mysql::Error => e
      puts "DB ERROR: "+e.error
    end
  end
  
  def getPlayerGames(sessionId)
    # Gets all the 'joinable' state games and games that the player is in (according to sessionId)
    # Hash has keys: game_id, player1_id, player2_id, state, game_model, server_address, last_update
    # Returns: Array of Hashes -- result
    pre_getPlayerGame(sessionId)
    begin
      res1 = @db.query("SELECT game_id, player1_id, player2_id, state, game_model, server_address, last_update FROM games g, players p\
                       WHERE p.session_id='#{sessionId} AND (g.player1_id=p.player_id OR g.player2_id=p.player_id) \
                       AND state='saved'");
      res2 = @db.query("SELECT game_id, player1_id, player2_id, state, game_mode, server_addres, last_update FROM Game WHERE state='joinable'")
    rescue Mysql::Error => e
      puts "DB ERROR: "+e.error
    end
    result = []
    res1.each_hash { |h|
      h['game_model'] = unserialize(h['game_mode'])
      result << h
    }
    res2.each_hash { |h|
      h['game_model'] = unserialize(h['game_mode'])
      result << h
    }
    post_getGame(result)
    return result
  end
  
  def newGame(sessionId,game)
    # Adds a game where the player associated with sessionId is player1
    # Assigns the server_address as the leastActiveServer
    # Returns: String -- gameId
    pre_newGame(sessionId, game)
    gameId = newGameID()
    begin
      @db.query("START TRANSACTION")
      playerId = getPlayerID(sessionId)
      if res.num_rows == 1
        server_address = getLeastActiveServer()
        addGame(gameId, playerId, 'NULL', state="joinable", game, server_address)
      end
      @db.query("COMMIT")
      
    rescue Mysql::Error => e
      puts "DB ERROR: "+e.error
    end
    post_newGame(gameId)
    return gameId
  end
  
  def addGame(gameID, player1ID="NULL", playet2ID="NULL", state="NULL", gameModel, server_address)
    # newGame mysql helper function
    # Propagates mysql error
    s_gameModel = serialize(gameModel)

    @db.query("START TRANSACTION")
    @db.query("INSERT INTO Game (game_id, player_id, player2_id, state, game_model, server_address, last_update) \
                  VALUES ( '#{gameID}', '#{player1id}', '#{player2id}', '#{state}', '#{s_game_model}', '#{server_address}', curdate()" )
    @db.query("COMMIT")
  end
  
  def joinGame(sessionId, gameId)
    # Joins game (if valid) and assigns playerId associated with session to the empty slot.
    # If game is saved, reassigns the server_address to leastActiveServer
    # Return: String -- server_address
    pre_joinGame(sessionId, gameId)
    begin
      @db.query("START TRANSACTION")
      playerId = getPlayerID()
      res = @db.query("SELECT * FROM Game WHERE game_id='#{gameId}' AND state='joinable'")
      if res.num_rows == 1
        game = res.fetch_hash
        if game['player1_id'].downcase == 'null' && game['player2_id'].downcase != playerId
          query = "UPDATE Game \
                      SET player1_id='#{playerId}', state='active', last_update = curdate() \
                      WHERE game_id='#{gameId}'"
        elsif game['player2_id'].downcase = 'null' && game['player1_id'].downcase != playerId
          query = "UPDATE Game \
                      SET player2_id='#{playerId}', state='active',last_update = curdate()\
                      WHERE game_id='#{gameId}'"
        else
          query = ""
        end
        @db.query(query);
        if game['server_address'].downcase =='null'
          server_address = getLeastActiveServer()
          @db.query("UPDATE Game \
                      SET server_address =  \
                      WHERE server_address='#{server_address}'")
        else
          server_address = game['server_address']
        end
      end
      @db.query("COMMIT")
      
    rescue Mysql::Error => e
      puts "DB ERROR: "+e.error
    end
    post_joinGame(server_address)
    return server_address
  end

  def getGame(gameId)
    # Returns the Game table record associated with gameId
    # Hash has keys: game_id, player1_id, player2_id, state, game_model, server_address, last_update
    # Returns: Hash -- result
    pre_getGame(gameId)
    begin
      res = @db.query("SELECT * FROM Game \
                       WHERE game_id='#{gameId}'")
    rescue Mysql::Error => e
      puts "DB ERROR: "+e.error
    end
    result = res.fetch_hash
    result['game_model'] = unserialize(result['game_mode'])
    post_getGame(result)
    return result
  end

  def updateGame(gameId, field, value)
    # Updates a field in the Game table with value
    # Returns: --
    pre_updateGame(gameId, field, value)
    begin
      @db.query("START TRANSACTION")
      @db.query("UPDATE Game \
                  SET #{field}='#{value}', last_update = CURDATE()  \
                  WHERE game_id=#{gameId}")
      @db.query("COMMIT")
    rescue Mysql::Error => e
      puts "DB ERROR: "+e.error
    end
    post_updateGame
  end

  def updateStat(sessionId, stat, delta)
    # Updates a playerId's stat by adding a delta value to the existing stat value
    # on record
    # i.e. updateState(sessionId, 'wins', 1)
    # Returns: --
    pre_updateStat(sessionId, stat, delta)
    begin
      playerId = getPlayerID(sessionId)
      @db.query("START TRANSACTION");
      @db.query("UPDATE Player \
                  SET #{stat}=#{stat}+ #{delta} \
                  WHERE player_id='#{playerId}'")
      @db.query("COMMIT")
      @db.query("UPDATE Player \
                  Set points=3*wins+draws \
                  WHERE player_id='#{playerId}'")
      
    rescue Mysql::Error => e
      puts "DB ERROR: "+e.error
    end
    post_updateStat
  end
  
  def getMyStats(sessionId)
    # Retrieves League stats for player associated to sessionId ordered by points
    # Hash has keys: username, points, wins, losses, draws
    # Returns: Hash -- result
    pre_getMyStats(sessionId)
    begin
      playerId = getPlayerID(sessionId)
      res = @db.query("SELECT username, points, wins, losses, draws FROM Player \
                WHERE username='#{playerId}'")
    rescue Mysql::Error => e
      puts "DB ERROR: "+e.error
    end
    result = res.fetch_hash if res.num_rows ==1
    post_getMyStats(result)
  end
  
  def getTopStats(n=0)
    # Retrieves the top n league stats
    # else if n==0 then display all league stats
    # Hash has keys: username, points, wins, losses, draws
    # Returns: Array of Hashes -- results
    pre_getTopstats
    results = []
    begin
      playerId = getPlayerID(sessionId)
      query = "SELECT username, points, wins, losses, draws \
                        FROM Player \
                        ORDER BY points"
      if n>=0
        query += " LIMIT 0,#{n}"
      end
      
      res = @db.query(query)
    rescue Mysql::Error => e
      puts "DB ERROR: "+e.error
    end
    res.each_hash {|h|
      results << h
    }
    post_getTopStats(results)
    return(results)
  end
  
  def getPlayerID(sessionId)
    # helper function to retrieve playerID associated with sessionID
    pre_getPlayerId(sessionId)
    # Propagates the mysql error
    res = @db.query("SELECT player_id FROM Session WHERE session_id='#{sessionId}'")
    
    result = res.fetch_hash
    post_getPlayerID(result['player_id'])
    return result['player_id']
  end
    
  
  def newGameID()
    length = 5
    return rand(36**length).to_s(36)
  end
  
  def newSessionID()
    length = 15
    return rand(36**length).to_s(36)
  end
  
  def serialize(gameBoard)
    return Marshal.dump(gameBoard)
  end
  
  def unserialize(stream)
    return Marshal.load(stream)
  end

    
end
  
  