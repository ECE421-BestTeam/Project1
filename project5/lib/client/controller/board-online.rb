require 'socket'
require 'xmlrpc/server'
require_relative './online-helper'

# local implementation of board controller
class BoardOnlineController
  include OnlineHelper
  
  attr_reader :settings, :localPlayers, :gameId
  
  def initialize (settings)
    @clientSettings = settings[:clientSettings]
    
    # open the connection
    connect
    
    # Start our receiver
    startReciever
    
    # get game
    @gameId = ''
    startGame settings[:gameSettings]
    
  end

  def startReciever
    @recieverThread = Thread.new do
      @recieverPort = 50500
      while true
        begin
          @reciever = XMLRPC::Server.new(@recieverPort)
          puts "receiver listening on #{@recieverPort}"
          break
        rescue Errno::EADDRINUSE
          @recieverPort += 1
          puts "incrementing receiver port to #{@recieverPort}"
          if @recieverPort > 50550
            raise IOError, "Can not start reciever."
          end
        end
      end
      @recieverStarted = true
      @reciever.add_handler('refresh') do |model|
#        puts 'HIIIYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY'
        begin
          @refresh.call model
        rescue Exception => e
          puts 'Refresh Failed:'
          msg = e['message']
          e['backtrace'].each do |level|
            msg += "\n\t#{level}"
          end
          puts msg
        end
        true
      end
    
      @reciever.serve
    end
  end
 
  def close
    if @recieverThread && @reciever
      @reciever.shutdown
      @recieverThread.kill
      @recieverThread.join
    end
  end
  
  # registers the refresh command so the 
  # controller can call it when needed
  def registerRefresh(refresh)
    @refresh = refresh
    handleResponse(Proc.new {
      @connection.call('getRefresh', @clientSettings.sessionId, @gameId, @localPlayers[0])
    })
  end
  
  # either starts a new game or joins an existing one
  def startGame(gameSettings)
    i = 0
    while !@recieverStarted
      sleep 0.2
      raise IOError, "Can't get turn for #{responseFn}" if i > 35
      i += 1
    end
    if gameSettings.class == String
      @gameId = gameSettings
      joinGame(@gameId)
    else 
      newGame(gameSettings)
    end
  end
  
  def newGame(gameSettings)
    # We want to create a new game
    handleResponse(Proc.new {
        @connection.call('newGame', @clientSettings.sessionId, gameSettings)
      },
      Proc.new do |data|
        @gameId = data
        # we were returned the new game ID
      end
    )
    joinGame(@gameId)
  end
  
  def joinGame(gameId)
    handleResponse(Proc.new {
        @connection.call('joinGame', @clientSettings.sessionId, gameId, {'host'=>local_ip,'port'=>@recieverPort})
      },
      Proc.new { |data|
        # we were returned the player Number
        @localPlayers = [data] 
      }
    )
  end
  
  #called when a player wishes to place a token
  def placeToken (col)
    handleResponse(Proc.new {
      @connection.call('placeToken', @clientSettings.sessionId, @gameId, col)
    })
  end
  
end