# handles all typical connect4.2 requests
class Server
  
  attr_reader :address, :games, :connections
  
  def initialize(port)
    @adress = "127.0.0.1:#{port}"
    @connections = 0
    @games = {} # hash of current games by gameid
    
    @db = Database.new
  end
  
  def handleNewConnection
    @connections += 1
  end
  
  def connectToGameServer(gameId)
    # check if game is currently checked out to a server
    game = @db.get(:games, gameId)
    serverAddress = game[:checkedOutTo]
    return serverAddress if serverAddress
    
    #else check it out
    game[:checkedOutTo] = @address
    @db.update(:games, game)
    @games[game[:id]] = game
    
  end
  
end