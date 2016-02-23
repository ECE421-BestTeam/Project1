require 'test/unit/assertions'

module ContractDelay
  include Test::Unit::Assertions
  # Module, so no class invariant

  def checkSeconds (seconds) 
    assert seconds.respond_to?(:to_f) && seconds.to_f >= 0, "seconds must be a positive float"
  end
  
  def pre_delayedAction(seconds)
    checkSeconds(seconds)
  end

  def post_delayedAction(seconds)
    # Message appears after specified time
  end
  
  def pre_delayedMessage(seconds, message)
    checkSeconds(seconds)
    assert message.class == String
  end

  def post_delayedMessage(seconds, message)
    # Message appears after specified time
  end

end