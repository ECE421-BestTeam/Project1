require 'test/unit/assertions'

require_relative './board'
require_relative '../../common/model/settings'

module MenuControllerContract
  include Test::Unit::Assertions
  
  def class_invariant
    assert @settings.class = SettingsModel, "settings must be a SettingsModel"
  end
  
  def pre_initialize(settings)
    assert settings.class = SettingsModel, "settings must be a SettingsModel"
  end

  def post_initialize
  end
  
  def pre_getBoardController
  end
  
  def post_getBoardController(result)
    assert result.class == BoardController, "boardController type must be a BoardController"
  end
    
end