require_relative './delay/delay'
require_relative './file-watch/file-watch'
require 'fileutils'

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
      puts 'Exiting'
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
      return false
    end
    return true
  end
    
  def self.cdHandler(args)
    return if argsCheck(args, 2) == false
    begin
      Dir.chdir(args[1])
      puts "Changed directory to " + Dir.pwd()
    rescue Errno::ENOENT
      puts "Directory " + args[1] + " does not exist"
    rescue => exception
      puts exception.message
      puts exception.backtrace
    end
  end
  def self.lsHandler(args)
    return if argsCheck(args, 1) == false
    begin
      Dir.entries(".").sort.each do |item|
        puts item
      end
    rescue => exception
      puts exception.message
      puts exception.backtrace
    end
  end
  def self.pwdHandler(args)
    return if argsCheck(args, 1) == false
    begin
      puts "Working directory: " + Dir.pwd()
    rescue => exception
      puts exception.message
      puts exception.backtrace
    end
  end
  
  def self.mkdirHandler(args)
    return if argsCheck(args, 2) == false
    begin
      Dir.mkdir(args[1])
      puts "Created directory " + args[1] + " in " + Dir.pwd()
    rescue Errno::EEXIST
      puts "Directory " + args[1] + " already exists in " + Dir.pwd()
    rescue => exception
      puts exception.message
      puts exception.backtrace
    end
  end
  def self.rmHandler(args)
    #Removes both files and directories
    return if argsCheck(args, 2) == false
    #Directory removal
    begin
      Dir.delete(args[1])
      puts "Deleted directory " + args[1] + " from " + Dir.pwd()
    rescue Errno::ENOTDIR
      #File removal
      begin
        FileUtils.rm(args[1])
        puts "Deleted file " + args[1] + " from " + Dir.pwd()
      rescue => exception
        puts exception.message
        puts exception.backtrace
      end
    rescue Errno::ENOENT
      puts args[1] + " does not exist in " + Dir.pwd()
    rescue Errno::ENOTEMPTY
      puts "Directory " + args[1] + " is not empty; cannot delete"
    rescue => exception
      puts exception.message
      puts exception.backtrace
    end
  end
  
  def self.delayedMessageHandler(args)
    return if argsCheck(args, 3) == false
    pid = Process.fork
    if pid == nil
      # do the delay
      delayedMessage(args[1], args[2])
    else
      Process.detach(pid)
    end
  end
  
  def self.filewatchHandler(args)
    if args.length == 0
      printf "USAGE: filewatch <mode> <optional time> <filename(s)> \"<command>\" \n"
      return
    end
    mode = args.shift
    files = []
    time = 0;
    while !args.empty?
      a = args.shift
      if a.respond_to?(:to_i)
        time = a
      elsif a.respond_to(:to_s) && a.match(".*")
        block = a
      elsif a.respond_to(:to_s) && a.match("[\S]+")
        files << f
      end
    end

    begin
      pid = Process.fork
      if pid.nil?
        f = FileWatch.new(mode,time,*files) { eval( "lambda {" + block + "}") }
      else
        Process.detach(pid)
      end
    rescue Interrupt
      abort('User terminated watching.')
    rescue StandardError => e
      abort('Error in execution: ' + e.to_s)
    end
    
  end
end
