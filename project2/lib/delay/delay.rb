require_relative './ext/delay'

def argsCheck (seconds, nanoSeconds)
  raise ArgumentError, "seconds must be a positive integer" if seconds.class != Fixnum || seconds < 0
  raise ArgumentError, "nanoSeconds must be an integer in [0, 999999999]" if nanoSeconds.class != Fixnum || nanoSeconds < 0 || nanoSeconds > 999999999
end

# delay an action by seconds+nanoSeconds
def delayedAction (seconds, nanoSeconds = 0, &func)
  seconds = seconds.to_i
  nanoSeconds = nanoSeconds.to_i
  argsCheck(seconds, nanoSeconds)
  C_Delay.delayedAction(seconds, nanoSeconds) {func.call()}  
end

# delay a message by seconds+nanoSeconds
def delayedMessage (seconds, nanoSeconds = 0, message)
  seconds = seconds.to_i
  nanoSeconds = nanoSeconds.to_i
  argsCheck(seconds, nanoSeconds)
  delayedAction(seconds, nanoSeconds) {puts message}
end