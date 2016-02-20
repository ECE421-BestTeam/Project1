require './shell_handlers.rb'

module CustomShell
  
  def run
    loop do
      cmd = gets
      if cmd.length < 1
        puts "Please enter a command."
        next
      else      
        ## This will handle all commands and calls to handlers
        ShellHandlers.masterHandler(cmd)
      end
    end
  end

end

include CustomShell
run()