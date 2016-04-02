require 'test/unit/assertions'

require_relative '../model/client-settings'
require_relative '../../common/model/game-settings'

module MenuControllerContract
  include Test::Unit::Assertions
  
  def class_invariant
    assert @settings.class = ClientSettingsModel, "settings must be a ClientSettingsModel"
  end
  
  def pre_initialize(settings)
    assert settings.class = ClientSettingsModel, "settings must be a ClientSettingsModel"
  end

  def post_initialize
  end
  
  def pre_getBoardController(settings)
    assert settings.class = GameSettingsModel, "settings must be a GameSettingsModel"
  end
  
  def post_getBoardController(result)
    assert result.class == BoardController, "boardController type must be a BoardController"
  end
    
end