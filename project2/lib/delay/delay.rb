require_relative './ext/delay'


def delay (seconds, &func)
  C_Delay.delay(seconds) {func.call()}  
end