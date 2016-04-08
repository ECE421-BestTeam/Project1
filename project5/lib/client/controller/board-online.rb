require 'socket'
require 'xmlrpc/server'
require_relative './online-helper'
require_relative '../../common/model/game'

# local implementation of board controller
class BoardOnlineController
  include OnlineHelper
  
  attr_reader :settings, :localPlayers
  
  def initialize (settings)
    @gameSettings = settings[:gameSettings]
    @clientSettings = settings[:clientSettings]
    
    # open the connection
    connect
    
    # Start our receiver
    startReciever
    
    
    # get game
    @game = getGame
    
    # set localPlayers based on game
    @localPlayers = @game #match with @clientSettings.sesionId  or .username?
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
  def getGame
    if @gameSetttings.class == String
      @gameId = @gameSettings
      joinGame(@gameId)
    else 
      newGame(@gameSettings)
      joinGame(@gameId)
    end
    
    #register the receiver
    handleResponse(
      @connection.call('registerReciever', @clientSettings.sessionId, "#{local_ip}:#{@recieverPort}"),
      Proc.new do |data|
        break
      end
    )
  end
  
  def newGame(gameSettings)
    # We want to create a new game
    handleResponse(
      @connection.call('newGame', @clientSettings.sessionId, gameSettings),
      Proc.new do |data|
        # we were returned the new game ID
        @gameId = data
      end
    )
  end
  
  def joinGame(gameId)
    handleResponse(
      @connection.call('joinGame', @clientSettings.sessionId, gameId),
      Proc.new do |data|
        # we were returned the new game
        @game = data['game_model']
        
        if data['player1_id'] == @clientSettings.username
          @localPlayers = [0] 
        elsif data['player2_id'] == @clientSettings.username
          @localPlayers = [1]
        else
          raise ArgumentError, "Player is not part of current game."
        end
        
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
