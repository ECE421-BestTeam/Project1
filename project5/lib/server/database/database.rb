require_relative './contract-database'
require 'json'
require 'mysql2'


class Database
  include DatabaseContract
  
  def initialize(address)
    pre_initialize
    
    begin
#      @db = Mysql.new("mysqlsrv.ece.ualberta.ca",
#      "placeholderusr",
#      "placeholderpwd",
#      "placeholderdbn",
#      13010
#      )
      @db= Mysql.new("localhost", nil, nil, 'test', nil)
    rescue Mysql::Error => e
      puts e.error
    end
    
    post_initialize
    class_invariant
  end
  
  def addStats(playerId, wins, losses, draws)
    pre_addStats(playerId, wins, losses, draws)
    begin
      @db.query("INSERT INTO playerStats (playerID, wins, losses, draws) \
              VALUES ( '#{playerId}', #{wins}, #{losses}, #{draws}" )
    rescue Mysql::Error => e
      puts "DB ERROR: Rolling back change"
      puts e.error
      @db.rollback
    end
    post_addStats
  end
  
  # updates a playerId's stat by adding a delta value to the existing stat value
  # on record
  def updateStat(playerId, stat, delta)
    pre_updateStat(playerId, stat, delta)
    begin
      @db.query("UPDATE playerStats \
                  SET #{stat}=#{stat}+ #{delta} \
                  WHERE playerID=#{playerId}")
    rescue Mysql::Error => e
      puts "DB ERROR: Rolling back change"
      puts e.error
      @db.rollback
    end
    post_updateStat
  end
  
  def getStats(playerId)
    pre_getStats(playerId)
    begin
      res = @db.query("SELECT * FROM playerStats \
                       WHERE playerID='#{playerI}'")
    rescue Mysql::Error => e
      puts e.error
    end
    result = res.fetch_hash
    post_getStats(result)
    return result
  end
  
  def addGame(gameID, player1ID=nil, playet2ID=nil, playerTurn=nil, gameBoard, state)
    pre_addGame(gameID, player1ID, player2ID, playerTurn, gameBoard, state)
    s_gameBoard = serializeBoard(gameBoard)
    begin
      @db.query("INSERT INTO games (gameID, player1ID, player2ID, playerTurn,\
                gameBoard, state) \
                VALUES ( '#{gameID}', #{niltonull(player1id)}, #{niltonull(player2id)}, #{niltonull(playerTurn)}, '#{s_gameBoard}' , '#{state}'" )
    rescue Mysql::Error => e
      puts "DB ERROR: Rolling back change"
      puts e.error
      @db.rollback
    end

    post_addGame
  end
  
  def updateGame(gameId, field, value)
    pre_updateGame(gameId, field, value)
    begin
      @db.query("UPDATE Games \
                  SET #{field}=#{value} \
                  WHERE gameID=#{gameId}")
    rescue Mysql::Error => e
      puts "DB ERROR: Rolling back change"
      puts e.error
      @db.rollback
    end
    post_updateGame
    return result
  end
  
  def getGame(gameId)
    pre_getGame(gameId)
    begin
      res = @db.query("SELECT * FROM games \
                       WHERE gameID='#{gameId}'")
    rescue Mysql::Error => e
      puts e.error
    end
    result = res.fetch_hash
    post_getGame(result)
    return result
  end
  
  def getPlayerGames(playerId)
    pre_getGame(gameId)
    begin
      res = @db.query("SELECT * FROM games \
                       WHERE player1ID='#{playerId} or player2ID='#{playerId}'")
    rescue Mysql::Error => e
      puts e.error
    end
    result = []
    res.each_hash { |h|
      result << h
    }
    post_getGame(result)
    return result
  end
  
  def checkLogin(username, password)
    pre_checkLogin(username, password)
    begin
      @db.query("select * from users where username='#{username} and password='#{password}'")
    rescue Mysql::Error => e
      puts e.error
    end
    result = @db.affected_rows == 1
    post_checkLogin(result)
  end
  
  def serializeBoard(gameBoard)
#    stream = "(" + gameBoard.size.to_s + "," + gameBoard[0].size.to_s + ")"
#    gameBoard.each{ |r|
#      r.each{ |c|
#        c = 'n' if c==nil
#        stream += c.to_s
#      }
#    }
#    return stream
  return JSON.generate(gameBoard)
  end
  
  def unserializeBoard(stream)
#    stream = stream.scan(/\w+/)
#    dim = stream[0..1]
#    board = stream[2].split("")
#    i = 0
#    gameBoard = Array.new(dim[0].to_i) { |r|
#      Array.new(dim[1].to_i) { |c|
#        b = board.shift
#        c = b=='n' ? nil : break
#      }
#    }
#    
#    return gameBoard
  return JSON.parse(stream)
  end
  
  def niltonull(value)
    if value == nil
      return "NULL"
    end
    return "'#{value}'"
  end
    
end
  
  