require_relative './ext/delay'
require_relative './delay_contract'

include ContractDelay

# delay an action by seconds+nanoSeconds
def delayedAction (seconds, nanoSeconds = 0, &func)
  pre_delayedAction(seconds, nanoSeconds)
  
  C_Delay.delayedAction(seconds, nanoSeconds) {func.call()}  
  
  post_delayedAction(seconds, nanoSeconds)
end

# delay a message by seconds+nanoSeconds
def delayedMessage (seconds, nanoSeconds = 0, message)
  pre_delayedMessage(seconds, nanoSeconds, message)
  
  delayedAction(seconds, nanoSeconds) {puts message}
  
  post_delayedMessage(seconds, nanoSeconds, message)
end