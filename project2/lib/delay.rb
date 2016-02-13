#USAGE
#require_relative './delay'
#delay(1000) {puts 'hi'}

waitHash = Hash.new

trap("CLD") {
  pid = Process.wait
  puts "Child pid #{pid}: terminated"
  func = waitHash[pid]
  func.call
  waitHash.delete(pid)
  exit
  puts 'not terminated'
}

# delays an action by time (ns)
def delay (time, &action)
  pid = fork
  if (pid != nil) #the parent process
    waitHash[pid] = action
  else #the child process
    puts "In child, pid = #$$"
    # do the c delay
    exit
  end  
end
