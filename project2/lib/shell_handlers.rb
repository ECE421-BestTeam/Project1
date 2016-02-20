require_relative './delay/delay'

module ShellHandlers
  
  def self.parseCmd (cmd)
    args = cmd.strip.split(' ')
    
    # need to deal with quoted arguments (args that include spaces)
    argIndexOfString = false
    quoteType = ''
    newArgs = []
    
    args.each_with_index do |arg, index|
      # if not in the middle of a string
      if !argIndexOfString
        # are we at the beginning of a string?
        quoteType = /^['"]/.match(arg).to_s
        if quoteType.length > 0
          argIndexOfString = index
        end
      end
      
      # are we in the middle of a string?
      if argIndexOfString
        
        # if the first arg in string
        if argIndexOfString == index
          newArgs.push(arg)
        else
          # append to current arg
          newArgs[newArgs.size - 1] += ' ' + args[index]
        end
        
        # match only if the arg ends with an un-escaped matching quote to stringStart
        if /[^\\]#{quoteType}$|^#{quoteType}$/.match(arg).to_s.length > 0
          # we are at the end of the string
          # remove quotes
          newArgs[newArgs.size - 1] = newArgs[newArgs.size - 1].slice(1, newArgs[newArgs.size - 1].length - 2)
          argIndexOfString = false
          quoteType = ''
        end
      else
        #just a normal arg
        newArgs.push(arg)
      end

    end
    
    # ensure strings were properly quoted
    if argIndexOfString
      raise ArgumentError, "String not properly quoted.  Ensure all quotation marks are paired.  (Escaped marks do not count in pairing)"
    end

    return newArgs
  end
  
  def self.masterHandler(cmd)
    begin
      args = parseCmd(cmd)
    rescue ArgumentError => e
      print 'Error in command: ', cmd
      puts e
      return
    end

    case args[0]
    when 'exit'
      puts 'exiting'
      exit 0
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
    when 'delayedMessage'
      delayedMessageHandler(args)
    when 'filewatch'
      filewatchHandler(args)
    else
      puts "Command not recognized."
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
  
  def self.delayedMessageHandler(args)
    argsCheck(args, 3)
    pid = Process.fork
    if pid == nil
      # do the delay
      delayedMessage(args[1].to_i, 0, args[2])
    else
      Process.detach(pid)
    end
  end
  
  def self.filewatchHandler(args)
    argsCheck(args, 5)
    puts "TODO: filewatch"
  end
end
