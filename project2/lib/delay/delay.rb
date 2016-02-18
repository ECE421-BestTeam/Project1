#USAGE
#require_relative './delay'
#delay(1000) {puts 'hi'}

# Just call a c func
# Create a new thread in C and let it handle everything




#  # delays an action by time (ns)
#  def delay (time, &action)
#    waitHash[pid] = action
#    pid = Process.spawn
#    if (pid != nil) #the parent process
#    else #the child process
#      puts "In child, pid = #$$"
#      # do the c delay
#      exit
#    end  
#  end
#
#delay(10) {puts 'hi'}