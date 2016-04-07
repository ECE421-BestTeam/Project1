require 'json'
require_relative './contract-client-settings'

# A model for the settings for the connect four game
class ClientSettingsModel
  include ClientSettingsContract
  
  attr_accessor :host, :port, :sessionId
  
  $saveFile = "../data/clientSaveData.json"
  
  # loads the settings from the save file (or enters defaults
  def initialize
    pre_initialize

    # defaults
    @host = "localhost"
    @port = 4222
    @sessionId = ''

    file = nil
    begin
      file = File.read($saveFile)
      file = JSON.parse(file)
      @host = file['host'] || @host
      @port = file['port'] || @port
      @sessionId = file['sessionId'] || @sessionId
    rescue Errno::ENOENT => e
      # just leave the defaults
    end
    
    class_invariant
    post_initialize
  end
  
  def save
    pre_save
    
    data = {
      :serverAddress => @serverAddress,
      :sessionId => @sessionId
    }
    File.write($saveFile, JSON.generate(data))
    
    class_invariant
    post_save
  end
  
end
