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
    startGame settings[:gameSettings]
    
  end

  def startReciever
    @recieverPort = 50500
    while true
      begin
        @reciever = XMLRPC::Server.new(@recieverPort)
        break
      rescue Errno::EADDRINUSE
        @recieverPort += 1
        if @recieverPort > 50550
          raise IOError, "Can not start reciever."
        end
      end
    end
    
    @reciever.add_handler('refresh') do |model|
      @resfresh.call model
    end
    @recieverThread = Thread.new do
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
    handleResponse(
      @connection.call('registerReciever', @clientSettings.sessionId, @gameId, local_ip)
    )
  end
  
  # either starts a new game or joins an existing one
  def startGame(gameSettings)
    if gameSettings.class == String
      joinGame(gameSettings)
    else 
      newGame(gameSettings)
    end
  end
  
  def newGame(gameSettings)
    # We want to create a new game
    handleResponse(
      @connection.call('newGame', @clientSettings.sessionId, gameSettings),
      Proc.new do |data|
        # we were returned the new game ID
        joinGame(data)
      end
    )
  end
  
  def joinGame(gameId)
    handleResponse(
      @connection.call('joinGame', @clientSettings.sessionId, gameId),
      Proc.new do |data|
        @gameId = gameId
        # we were returned the player Number
        @localPlayers = [data] 
      end
    )
  end
  
  #called when a player wishes to place a token
  def placeToken (col)
    handleResponse(
      @connection.call('placeToken', @clientSettings.sessionId, @gameId, col)
    )
  end
  
end
