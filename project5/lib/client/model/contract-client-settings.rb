require 'test/unit/assertions'

module ClientSettingsContract
  include Test::Unit::Assertions
  
  def class_invariant
    assert @serverAddress.class == String, "serverAddress must be a String"
    assert @sessionId.class == String || @sessionId.class == NilClass, "sessionId must be a String"
  end
  
  def pre_initialize
  end

  def post_initialize
  end
  
  def pre_save
  end

  def post_save
  end
  
end