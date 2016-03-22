require 'socket'
require_relative './database/database'

# a server for all things connect4.2
class Server
  
  def initialize(port)
    @port = port
    
    @db = Database.new
    
    @continue = true
    @server = TCPServer.open(port)
    puts "listening on #{port}"
    loop
    
  end
  
  def loop
    while @continue
#      client = @server.accept
      th = Thread.start(@server.accept) do |client, client_addr|
        client.puts "ok" # let client know connection was successful
        
        while true do
          # get client request
          req = client.gets.chomp
          res = nil
          case req
            when "close"
              break
            when "stats"
              res = getStats(client)
            when "newGame"
              res = newGame(client)
            when "existingGame"
              res = joinExistingGame(client)
            else
              res = "invalid"  
          end
          client.puts res # respond
        end
        
        client.close # Disconnect from the client
      end
    end
  end
  
  def getStats(client)
    return "not implemented"
  end
  
  def newGame(client)
    a = client.addr
    myHost = a[3]
    client.puts "ok" # proceed
    gameId = client.gets.chomp
    return "not implemented"
  end
  
  def joinExistingGame(client)
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