require_relative './ext/delay'

# delay an action by seconds+nanoSeconds
def delayedAction (seconds, nanoSeconds = 0, &func)
  C_Delay.delayedAction(seconds, nanoSeconds) {func.call()}  
end

# delay a message by seconds+nanoSeconds
def delayedMessage (seconds, nanoSeconds = 0, message)
  delayedAction(seconds, nanoSeconds) {puts message}
end