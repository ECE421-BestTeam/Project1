require_relative './database/database'

# handles all typical connect4.2 game requests
class MenuServer
  
  attr_reader :address, :connections
  
  def initialize(port)
    @adress = "127.0.0.1:#{port}"
    @connections = 0
    
    @db = Database.new
  end
  
  def openConnection
    @connections += 1
  end

  def closeConnection
    @connections += 1
  end
  
  # returns json object containing all the stats
  # playerId, wins, draws, losses, active
  def getStats

  end

end