require_relative './delay_contract'

module Delay
#  include ContractDelay

  # delay an action by seconds+nanoSeconds
  def Delay.delayedAction (seconds = 0.0, &func)
    ContractDelay.pre_delayedAction(seconds)

    sleep seconds.to_f
    func.call()

    ContractDelay.post_delayedAction(seconds)
  end

  # delay a message by seconds+nanoSeconds
  def Delay.delayedMessage (seconds = 0.0, message)
    ContractDelay.pre_delayedMessage(seconds, message)

    delayedAction(seconds) {puts message}

    ContractDelay.post_delayedMessage(seconds, message)
  end
end