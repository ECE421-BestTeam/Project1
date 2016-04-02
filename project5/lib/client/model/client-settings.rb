require_relative './contract-client-settings'

# A model for the settings for the connect four game
class ClientSettingsModel
  include ClientSettingsContract
  
  attr_accessor :serverAddress, :sessionId
  
  $saveFile = "../data/clientSaveData.json"
  
  # loads the settings from the save file (or enters defaults
  def initialize
    pre_initialize
    
    file = nil
    begin
      file = File.read($saveFile)
      file = JSON.parse(file)
      @serverAddress = file[:serverAddress]
      @sessionId = file[:sessionId]
    rescue Errno::ENOENT => e
      @serverAddress = "localhost:4222"
      @sessionId = nil
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
