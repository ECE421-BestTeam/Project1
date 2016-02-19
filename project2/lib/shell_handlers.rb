module ShellHandlers
  def self.masterHandler(args)
    pid = Process.fork
    if pid == nil
      case args[0]
      when 'cd'
        cdHandler(args)
      when 'ls'
        lsHandler(args)
      when 'pwd'
        pwdHandler(args)
      when 'mkdir'
        mkdirHandler(args)
      when 'rm'
        rmHandler(args)
      when 'delay'
        delayHandler(args)
      when 'filewatch'
        filewatchHandler(args)
      else
        puts "Command not recognized."
      end
      exit
    else
      Process.waitpid(pid)
    end
  end

  def self.argsCheck(args, count)
    if args.size != count
      puts "%s takes %d argument(s)." % [args[0], count - 1]
      exit
    end
  end
    
  def self.cdHandler(args)
    argsCheck(args, 2)
    puts "TODO: cd"
  end
  def self.lsHandler(args)
    argsCheck(args, 1)
    puts "TODO: ls"
  end
  def self.pwdHandler(args)
    argsCheck(args, 1)
    puts "TODO: pwd"
  end
  
  def self.mkdirHandler(args)
    argsCheck(args, 2)
    puts "TODO: mkdir"
  end
  def self.rmHandler(args)
    argsCheck(args, 2)
    puts "TODO: rm"
  end
  
  def self.delayHandler(args)
    argsCheck(args, 3)
    puts "TODO: delay"
  end
  def self.filewatchHandler(args)
    argsCheck(args, 5)
    puts "TODO: filewatch"
  end
end
