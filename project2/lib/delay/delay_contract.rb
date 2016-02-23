require 'test/unit/assertions'

module ContractDelay
  include Test::Unit::Assertions
  # Module, so no class invariant

  def ContractDelay.checkSeconds (seconds) 
    assert seconds.respond_to?(:to_f) && seconds.to_f >= 0, "seconds must be a positive float"
  end
  
  def ContractDelay.pre_delayedAction(seconds)
    ContractDelay.checkSeconds(seconds)
  end

  def ContractDelay.post_delayedAction(seconds)
    # Message appears after specified time
  end
  
  def ContractDelay.pre_delayedMessage(seconds, message)
    ContractDelay.checkSeconds(seconds)
    assert message.class == String
  end

  def ContractDelay.post_delayedMessage(seconds, message)
    # Message appears after specified time
  end

end