require_relative './database/database'

# handles all typical connect4.2 game requests
class GameServer
  
  attr_reader :address, :connections
  
  def initialize(port)
    @adress = "127.0.0.1:#{port}"
    @connections = 0
    @games = {} # hash of current games by gameid
    
    @db = Database.new
  end
  
  # checks that the gameId and playerId is valid for this server
  # returns true/false for success/failure
  def checkRequest(gameId, playerId)
    # if gameId not in games
    # return something that indicates that they should ask the hub for a server
    # maybe directly redirect to hub
    
    # if playerId is not included in the game
    # return something like invalid request
    
    # otherwise
    return true
  end
  
  def openConnection(gameId, playerId)
    @connections += 1
    # add gameId to games if not already there
  end
  
  def placeToken(gameId, playerId)
    return if !checkRequest(gameId, playerId)
    
    # do the place token
  end
  
  def getNextActiveState(gameId, playerId)
    return if !checkRequest(gameId, playerId)
    
    # wait for the next active state
  end
  
  # needs to be called by both players or timed out for both players
  def closeConnection(gameId, playerId)
    return if !checkRequest(gameId, playerId)
    
    # remove playerId from active players in game
    # decrement connections
    
    # check that it has been called twice for this game
    # (game should have no active players)
    
    # if the game has a winner
    # remove the game from games db
    # update stats
    
    # if game has no winner
    # update the game (save it)
    
  end

end