require 'socket'
require_relative './online-helper'
require_relative '../../common/model/game'

# local implementation of board controller
class BoardOnlineController
  include OnlineHelper
  
  attr_reader :settings, :localPlayers
  
  def initialize (settings)
    @gameSettings = settings[:gameSettings]
    @clientSettings = settings[:clientSettings]
    
    # Start our reciever
    startReciever
    
    # open the connection
    connect
    
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
      end
      @recieverPort += 1
      if @recieverPort > 50550
        raise IOError, "Can not start reciever."
      end
    end
    
    @reciever.add_handler('refresh') do |model|
      @resfresh.call model
    end
    
    @reciever.serve
  end
 
  # registers the refresh command so the 
  # controller can call it when needed
  def registerRefresh(refresh)
    @refresh = refresh
    @refresh.call @game
  end
  
  # either starts a new game or joins an existing one
  def getGame
    if @gameSetttings.class == String
      # we want to join a game
      handleResponse(
        connection.call('joinGame', @clientSettings.sessionId, @gameSettings),
        Proc.new do |data|
          # we were returned the new game ID
          @game = data
        end
      )
    else 
      # We want to create a new game
      handleResponse(
        connection.call('newGame', @clientSettings.sessionId, @gameSettings),
        Proc.new do |data|
          # we were returned the new game ID
          @gameSettings = data
        end
      )
      getGame
    end
    
    #register the receiver
    handleResponse(
      connection.call('registerReciever', @clientSettings.sessionId, "#{local_ip}:#{@recieverPort}"),
      Proc.new do |data|
        break
      end
    )
  end
    
  def close
    #close the connection
    @connection.close
  end
  
  #called when a player wishes to place a token
  def placeToken (col)
    handleResponse(
      connection.call('placeToken', @clientSettings.sessionId, col),
      Proc.new do |data|
        # we were returned the new game ID
        @game = data
      end
    )
    @refresh.call @game
  end
  
end