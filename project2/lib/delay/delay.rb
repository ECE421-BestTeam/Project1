require_relative './delay_contract'

include ContractDelay

# delay an action by seconds+nanoSeconds
def delayedAction (seconds = 0.0, &func)
  pre_delayedAction(seconds)
  
  sleep seconds.to_f
  func.call()
  
  post_delayedAction(seconds)
end

# delay a message by seconds+nanoSeconds
def delayedMessage (seconds = 0.0, message)
  pre_delayedMessage(seconds, message)
  
  delayedAction(seconds) {puts message}
  
  post_delayedMessage(seconds, message)
end