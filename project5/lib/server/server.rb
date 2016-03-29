require 'socket'
require 'json'
require_relative './database/database'

# a server for all things connect4.2
class Server
  
  # time out is how long before a client is deemed inactive
  def initialize(port, timeout = 60 * 60)
    @port = port
    @timeout = timeout # default is an hour
    
    @db = Database.new
    
    @continue = true
    @server = TCPServer.open(port)
    puts "listening on #{port}"
    
    loop
    
  end
  
  def loop
    while @continue
#      client = @server.accept
      Thread.start(@server.accept) do |client, client_addr|
        client.puts "ok" # let client know connection was successful
        
        while true do
          # get client request
          req = getRequest(client)
          res = nil
          begin
            # choose our handler
            case req
              when "closeConnection"
                break
              when "createPlayer"
                createPlayer(client)
              when "login"
                login(client)
              when "logout"
                logout(client)
              when "getStats"
                getStats(client)
              when "getGames"
                getGames(client)
              when "newGame"
                newGame(client)
              when "joinGame"
                joinGame(client)
              when "placeToken"
                placeToken(client)
              when "saveRequest"
                saveRequest(client)
              when "saveResponse"
                saveResponse(client)
              when "forfeit"
                forfeit(client)
              when "getGame"
                getGame(client)
              else
                res = buildResponse(:invalid, "invalid request '#{req}'")
            end
          rescue Exception => e
            res = buildResponse(:exception, e.msg)
          end
          
          client.puts res if res
        end
        
        puts 'closing server'
        client.close # Disconnect from the client
      end
    end
  end
  
  def getRequest(client)
    req = nil
    begin
      Timeout::timeout(@timeout) {
        req = client.gets.chomp
      }
    rescue Timeout
      req = "close"  # defaults to close if the client appears to be gone
    end
    return req
  end
  
  def buildResponse(status, data) 
    JSON.generate({:status => status, :data => data})
  end
  
  # attempts to create a player
  def createPlayer(client)
    client.puts buildResponse(:ok, "data") 
  end
  
  # attempts to login a client, will create a session on success
  # resturns the session id
  def login(client)
    client.puts buildResponse(:ok, "data")
  end  
  
  # logs a client out, destroys their session
  def logout(client)
    client.puts buildResponse(:ok, "data")
  end  
  
  # returns all of the stats
  def getStats(client)
    client.puts buildResponse(:ok, "data") 
  end

  # returns the list of games the player is involved in
  def getGames(client)
    client.puts buildResponse(:ok, "data")
  end  

  # returns the address of the server that the game will be hosted on
  def newGame(client)
    a = client.addr
    myHost = a[3]
    gameId = client.gets.chomp
    client.puts buildResponse(:ok, "data")
  end
  
  # returns the address of the server that the game is hosted on
  def joinGame(client)
    client.puts "ok" # proceed
    gameId = client.gets.chomp
    
    # ensure we are only trying to check out a game one at a time
    @db.checkOut(:games, gameId) do |game|
      if !game # Invalid gameId
        return "invalid"
      end

      # check if game is currently checked out to a server
      serverAddress = game[:checkedOutTo]
      # send there
      return serverAddress if serverAddress

      #else check it out to us
      game[:checkedOutTo] = address
      @db.update(:games, game)
      return address
    end
    client.puts buildResponse(:ok, "data")
    
  end
  
  # returns the list of games the player is involved in
  def placeToken(client)
    client.puts buildResponse(:ok, "data")
  end  
  
  # sends a request for save
  def saveRequest(client)
    client.puts buildResponse(:ok, "data")
  end
  
  # responds to a save request
  def saveRespond(client)
    client.puts buildResponse(:ok, "data")
  end

  # allows a client to forfeit
  def forfeit(client)
    client.puts buildResponse(:ok, "data")
  end
  
  # returns the game model
  def getGame(client)
    client.puts buildResponse(:ok, "data")
  end

  def myPossibleIps
    result = []
    addr_infos = Socket.ip_address_list
    addr_infos.each do |addr_info|
  #    if addr_info.ipv4_private? || addr_info.ipv6_private? 
        result.push addr_info.ip_address
  #    end
    end
    return result
  end

end