require_relative './shell_handlers'

module CustomShell
  
  def run
    loop do
      print "> " #Something to denote where user input goes
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
