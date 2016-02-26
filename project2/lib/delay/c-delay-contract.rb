require 'test/unit/assertions'

module ContractDelay
  include Test::Unit::Assertions
  # Module, so no class invariant

  def checkSeconds (seconds, nanoSeconds) 
    assert seconds.class == Fixnum && seconds >= 0, "seconds must be a positive integer"
    assert nanoSeconds.class == Fixnum && nanoSeconds >= 0 && nanoSeconds <= 999999999, "nanoSeconds must be an integer in [0, 999999999]"
  end
  
  def pre_delayedAction(seconds, nanoSeconds)
    checkSeconds(seconds, nanoSeconds)
  end

  def post_delayedAction(seconds, nanoSeconds)
    # Message appears after specified time
  end
  
  def pre_delayedMessage(seconds, nanoSeconds, message)
    checkSeconds(seconds, nanoSeconds)
    assert message.class == String
  end

  def post_delayedMessage(seconds, nanoSeconds, message)
    # Message appears after specified time
  end

end