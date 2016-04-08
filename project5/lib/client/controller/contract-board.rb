require 'test/unit/assertions'
require_relative '../../common/model/game'
require_relative '../../common/model/game-settings'
require_relative '../model/client-settings'

# handles the creation and playing of a game
module BoardControllerContract
  include Test::Unit::Assertions
  
  def class_invariant
    assert @implementation, "implementation must exist"
  end
  
  def pre_initialize(type, settings)
    assert type.class == Symbol && [:boardControllerLocal, :boardControllerOnline].include?(type), "type must be a Symbol in [:boardControllerLocal, :boardControllerOnline]"
    assert settings.class == Hash, "settings must be a Hash"
    # settings should be a hash with contents dependant on the type
    assert [GameSettingsModel, String].include?(settings[:gameSettings].class), "settings must contain gameSettings which is either a GameSettingsModel or a game ID String"
    case type
      when :boardControllerLocal
        # nothing else required
      when :boardControllerOnline
        assert settings[:clientSettings].class == ClientSettingsModel, "settings for BoardControllerOnline must contain clientSettings with a ClientSettingsModel"
    end
  end
  
  def post_initialize
  end

  def pre_settings
  end
  
  def post_settings(result)
    assert [GameSettingsModel, String].include?result.class, "gameSettings must be a GameSettingsModel or game ID String, not #{settings.class}"
  end
  
  def pre_localPlayers
  end
  
  def post_localPlayers(result)
    assert result.class == Array, "result must be an Array"
  end
  
  def pre_registerRefresh(refresh)
    assert refresh.arity == 1 && (refresh.class == Proc || refresh.class == Method), "refresh must be a function which accepts one argument"
  end
  
  def post_registerRefresh
  end
  
  def pre_close
  end
  
  def post_close
  end
  
  def pre_placeToken(col)
    assert col.class == Fixnum, "col must be a Fixnum"
  end
  
  def post_placeToken
  end
  
end