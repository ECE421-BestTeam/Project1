require 'json'
require 'mysql2'
require 'securerandom'
require_relative './contract-database'

class Database
  include DatabaseContract
  
  $dbSettingsFile = "#{File.expand_path File.dirname(__FILE__)}/db-settings.json"
  $dbSettingsTemplate = "#{File.expand_path File.dirname(__FILE__)}/db-settings-template.json"
  $tableKeys = {
    'Game' => 'game_id',
    'Server' => 'server_address',
    'Player' => 'username'
  }
  
  def initialize
    pre_initialize
    
    begin
      dbSettings = File.read($dbSettingsFile)
      dbSettings = JSON.parse(dbSettings)
      
      @db = Mysql2::Client.new(dbSettings)
#      @db = Mysql.new(
#        dbSettings["host"],
#        dbSettings["username"],
#        dbSettings["password"],
#        dbSettings["database"],
#        Integer(dbSettings["port"])
#      )
#      @db= Mysql.new("localhost", 'root', nil, 'ece421grp4', nil)
#    rescue Mysql::Error => e
#      puts e.error
    rescue Mysql2::Error => e
      puts "Please Ensure #{$dbSettingsFile} is populated correctly."
      raise e
    rescue Errno::ENONET => e
      puts "Please Ensure #{$dbSettingsFile} exists and is populated correctly."
      puts "You can find an example at #{$dbSettingsTemplate}."
      raise e
    end
    
    post_initialize
    class_invariant
  end
  
  def registerServer(serverAddress)
    # Adds serverAddress to server table if new
    # returns its game_ids
    # Returns: Array of Strings -- game_ids
    pre_registerServer(serverAddress)
    game_ids = [];

    @db.query("START TRANSACTION")
    @db.query("SELECT * FROM Server \
                  WHERE server_address='#{serverAddress}'" )
    if @db.affected_rows <= 0
      @db.query("INSERT INTO Server(server_address, data) VALUES('#{serverAddress}','')")
    else
      game_ids = getServerGames(serverAddress)
    end
    @db.query("COMMIT")
    post_registerServer(game_ids)
    return game_ids
  end
  
  def setServerData(serverAddress, data)
    #TODO: Contract
    pre_setServerData(serverAddress, data)
    d = serialize(data)
    puts d
    @db.query("START TRANSACTION")
    @db.query("UPDATE Server \
                SET data='#{d}' \
                WHERE server_address='#{serverAddress}'")
    @db.query("COMMIT")
    post_setServerData
  end
  
  def getServerData(serverAddress)
    #TODO: Contract
    pre_getServerData(serverAddress)
    res = @db.query("SELECT * FROM Server WHERE server_address='#{serverAddress}'")
    if @db.affected_rows >=1
      result = res.first
      data = unserialize(result['data'])
    else
      raise ArgumentError, "Provided server address does not exist"
    end
    post_getServerData(data)
    return data
  end
  
  def getLeastActiveServer
    # Gets the server address with the least amount of games assigned to it
    # Returns: String -- server_address
    pre_getLeastActiveServer

    res = @db.query("SELECT server_address, count(game_id) AS num_games FROM server s \
                        NATURAL LEFT JOIN game g GROUP BY server_address \
                        ORDER BY num_games limit 1" )
    server = res.first
    post_getLeastActiveServer(server['server_address'])
    return server['server_address']
  end
  
  def getServerGames(serverAddress)
    # Gets an a list of game_id associated with a serverAddress
    # Returns: Array of Strings -- game_id
    pre_getServerGames(serverAddress)
    result = []
    
    @db.query("START TRANSACTION")
    res = @db.query("SELECT g.game_id as game_id\
                  FROM Server s, Game g \
                  WHERE s.server_address=g.server_address")
    @db.query("COMMIT")
    
    
    
    res.each {|h|
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
    
    
    @db.query("START TRANSACTION")
    @db.query("INSERT INTO Player(username, password, points, wins, losses, draws, current_session_id) \
                  VALUES ( '#{username}', '#{password}',0, 0, 0, 0, '')" )
    @db.query("COMMIT")
    
    sess_id = assignNewSessionID(username)

    post_createPlayer(sess_id)
    return sess_id
  end
  
  def checkLogin(username, password)
    # Checks credentials against Player table
    # Updates player sessionID and Session table
    # Return Boolean -- true or false
    pre_checklogin(username, password)
    result = ""
    
    @db.query("SELECT * from Player WHERE username='#{username}' and password='#{password}'")
    if @db.affected_rows == 1
      sess_id = assignNewSessionID(username)        
      result = sess_id
    else 
      raise ArgumentError, "Invalid credentials"
    end

    post_checkLogin(result)
    return result
  end
  
  def logout(sessionId)
    # Remove sessionID from Player record
    # and Session table
    # Returns: --
    pre_logout(sessionId)
    
    @db.query("START TRANSACTION")
    @db.query("UPDATE Player \
                SET current_session_id=''\
                WHERE username = '#{username}'")
    @db.query("DELETE FROM Session WHERE session_id='#{sessionId}'")
    @db.query("COMMIT")
    return true
  end
  
  def getPlayerGames(sessionId)
    # Gets all the 'joinable' state games and games that the player is in (according to sessionId)
    # Hash has keys: game_id, player1_id, player2_id, state, game_model, server_address, last_update
    # Returns: Array of Hashes -- result
    pre_getPlayerGames(sessionId)
    
    res1 = @db.query("SELECT game_id, player1_id, player2_id, state, game_model, server_address, last_update FROM games g, players p\
                       WHERE p.session_id='#{sessionId} AND (g.player1_id=p.player_id OR g.player2_id=p.player_id) \
                       AND state='saved'");
    res2 = @db.query("SELECT game_id, player1_id, player2_id, state, game_mode, server_addres, last_update FROM Game WHERE state='joinable'")
    
    
    
    result = []
    res1.each { |h|
      h['game_model'] = unserialize(h['game_model'])
      result << h
    }
    res2.each { |h|
      h['game_model'] = unserialize(h['game_model'])
      result << h
    }
    post_getPlayerGames(result)
    return result
  end
  
  def newGame(sessionId, game)
    # Adds a game where the player associated with sessionId is player1
    # Assigns the server_address as the leastActiveServer
    # Returns: String -- gameId
    pre_newGame(sessionId, game)
    gameId = newGameID()
    
    @db.query("START TRANSACTION")
    playerId = getPlayerID(sessionId)
    server_address = getLeastActiveServer()
    addGame(gameId, playerId, "", "joinable", game, server_address)
    @db.query("COMMIT")
  
    post_newGame(gameId)
    return gameId
  end
  
  def addGame(gameID, player1ID, player2ID="", state, gameModel, server_address)
    # newGame mysql helper function
    # Propagates mysql error
    s_gameModel = serialize(gameModel)

    @db.query("START TRANSACTION")
    @db.query("INSERT INTO Game (game_id, player1_id, player2_id, state, game_model, server_address, last_update) \
                  VALUES ( '#{gameID}', '#{player1ID}', '#{player2ID}', '#{state}', '#{s_gameModel}', '#{server_address}', curdate())" )
    @db.query("COMMIT")
  end
  
  def joinGame(sessionId, gameId)
    # Joins game (if valid) and assigns playerId associated with session to the empty slot.
    # If game is saved, reassigns the server_address to leastActiveServer
    # Return: String -- server_address
    pre_joinGame(sessionId, gameId)
    
    canJoin = false
    
    @db.query("START TRANSACTION")
    playerId = getPlayerID(sessionId)
    res = @db.query("SELECT * FROM Game WHERE game_id='#{gameId}'")
    if @db.affected_rows == 1
      game = res.first
      game['game_model'] = unserialize(game['game_model'])
      # Is player already part of game?
      if [game['player1_id'], game['player2_id']].include? playerId
        canJoin = true
        
      elsif game['state'] == 'joinable'
        # they can also join the game! (probably!)
        freePlayerSlot = nil
        if game['player2_id'] == ""
          freePlayerSlot = '2'
        elsif game['player1_id'] == ""
          freePlayerSlot = '1'
        end
        
        if freePlayerSlot
          canJoin = true
          query = "UPDATE Game \
                      SET player#{freePlayerSlot}_id='#{playerId}', state='active', last_update = curdate() \
                      WHERE game_id='#{gameId}'"
          @db.query(query);
        end
      end
      
      if canJoin 
        if game['server_address'].downcase ==""
        server_address = getLeastActiveServer()
        @db.query("UPDATE Game \
                    SET server_address =  \
                    WHERE server_address='#{server_address}'")
          game['server_address'] = server_address
        end
        @db.query("COMMIT")
        post_joinGame(game)
        return game
      end      
    
    end
    
    raise ArgumentError, "Player can not join game."

  end

  def getGame(gameId)
    # Returns the Game table record associated with gameId
    # Hash has keys: game_id, player1_id, player2_id, state, game_model, server_address, last_update
    # Returns: Hash -- result
    pre_getGame(gameId)
    res = @db.query("SELECT * FROM Game \
                       WHERE game_id='#{gameId}'")  
    result = res.first
    result['game_model'] = unserialize(result['game_model'])
    post_getGame(result)
    return result
  end

  def updateGame(gameId, field, value)
    # Updates a field in the Game table with value
    # Returns: --
    pre_updateGame(gameId, field, value)
    if field == 'game_model'
      value = serialize(value)
    end
    
    @db.query("START TRANSACTION")
    @db.query("UPDATE Game SET #{field}='#{value}', last_update=curdate() WHERE game_id='#{gameId}'")
    @db.query("COMMIT")
  
    post_updateGame
  end

  def updateStat(sessionId, stat, delta)
    # Updates a playerId's stat by adding a delta value to the existing stat value
    # on record
    # i.e. updateState(sessionId, 'wins', 1)
    # Returns: --
    pre_updateStat(sessionId, stat, delta)
    
    playerId = getPlayerID(sessionId)
    @db.query("START TRANSACTION");
    @db.query("UPDATE Player \
                SET #{stat}=#{stat}+ #{delta} \
                WHERE player_id='#{playerId}'")
    @db.query("COMMIT")
    @db.query("UPDATE Player \
                Set points=3*wins+draws \
                WHERE player_id='#{playerId}'")
    post_updateStat
  end
  
  def getMyStats(sessionId)
    # Retrieves League stats for player associated to sessionId ordered by points
    # Hash has keys: username, points, wins, losses, draws
    # Returns: Hash -- result
    pre_getMyStats(sessionId)
    
    playerId = getPlayerID(sessionId)
    res = @db.query("SELECT username, points, wins, losses, draws FROM Player \
              WHERE username='#{playerId}'")

    result = res.first if @db.affected_rows ==1
    post_getMyStats(result)
    return result
  end
  
  def getTopStats(n=0)
    # Retrieves the top n league stats
    # else if n==0 then display all league stats
    # Hash has keys: username, points, wins, losses, draws
    # Returns: Array of Hashes -- results
    pre_getTopStats(n)
    results = []
    
    query = "SELECT username, points, wins, losses, draws \
                      FROM Player \
                      ORDER BY points"
    if n>=0
      query += " LIMIT 0,#{n}"
    end
    res = @db.query(query)

    res.each {|h|
      results << h
    }
    post_getTopStats(results)
    return(results)
  end
  
  def getPlayerID(sessionId)
    # helper function to retrieve playerID associated with sessionID
    pre_getPlayerID(sessionId)
    # Propagates the mysql error
    res = @db.query("SELECT username FROM Player WHERE current_session_id='#{sessionId}'")
    
    result = res.first
    raise ArgumentError, "invalid SessionId.  Please re-authenticate." if !result
    
    post_getPlayerID(result['username'])
    return result['username']
  end
    
  def remove(table, id)
    @db.query("DELETE FROM #{table} WHERE #{$tableKeys[table]}='#{id}'")    
  end
  
  def newGameID()
    length = 5
    return rand(36**length).to_s(36)
  end
  
  # assigns a new session Id to the player
  def assignNewSessionID(playerId)
    length = 15
    
    while true
      @db.query("START TRANSACTION")

      #find a unique sessionId
      res = []
      id = rand(36**length).to_s(36)
      res = @db.query("SELECT current_session_id FROM Player \
                WHERE current_session_id='#{id}'")
    
      if @db.affected_rows == 0
        # add it to the player
        @db.query("UPDATE Player \
                  SET current_session_id='#{id}' \
                  WHERE username='#{playerId}'")
        @db.query("COMMIT")
        break
      end
    
      @db.query("COMMIT")
    end
      
    return id
  end
  
  def serialize(gameBoard)
    return Marshal.dump(gameBoard)
  end
  
  def unserialize(stream)
    return Marshal.load(stream)
  end

    
end
