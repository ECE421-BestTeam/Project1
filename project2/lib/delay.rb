#USAGE
#require_relative './delay'
#delay(1000) {puts 'hi'}

Thread.new do
  waitHash = Hash.new

  while (true) 
    begin  
      pid = Process.wait
      puts pid
      handleChild(pid)
    rescue Errno::ECHILD => ex
      puts ex
      sleep # sleep until a thread finishes and wakes this one
    end

  end


  # delays an action by time (ns)
  def delay (time, &action)
    waitHash[pid] = action
    pid = Process.spawn
    if (pid != nil) #the parent process
    else #the child process
      puts "In child, pid = #$$"
      # do the c delay
      exit
    end  
  end

  private
  def handleChild (pid)
    puts "Child pid #{pid}: terminated"
    func = waitHash[pid]
    func.call
    waitHash.delete(pid)
  end
  
end


delay(10) {puts 'hi'}