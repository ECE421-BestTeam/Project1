require_relative './delay/delay'
require_relative './file-watch/file-watch'
require 'fileutils'

module ShellHandlers
  include Delay
  
  def parseCmd (cmd)
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
        
        # do not check for end if we are the first of the string and only 1 long
        # because it will incorrectly detect this as the last quote as well
        if !(argIndexOfString == index and arg.length == 1)
        # match only if the arg ends with an un-escaped matching quote to stringStart
          if /[^\\]#{quoteType}$|^#{quoteType}$/.match(arg).to_s.length > 0
            # we are at the end of the string
            # remove quotes
            newArgs[newArgs.size - 1] = newArgs[newArgs.size - 1].slice(1, newArgs[newArgs.size - 1].length - 2)
            argIndexOfString = false
            quoteType = ''
          end
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
  
  def masterHandler(cmd)
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
    when 'touch'
      touchHandler(args)
    when 'delayedMessage'
      delayedMessageHandler(args)
    when 'delayedAction'
      delayedActionHandler(args)
    when 'filewatch'
      filewatchHandler(args)
    else
      puts "Command not recognized."
    end

  end

  def argsCheck(args, count, argUsage)
    puts argUsage if args.length != count
    return args.length == count
  end
    
  def cdHandler(args)
    return unless argsCheck(args, 2, "USAGE: cd <path>")
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
  def lsHandler(args)
    return unless argsCheck(args, 1, "USAGE: ls")
    begin
      Dir.entries(".").sort.each do |item|
        puts item
      end
    rescue => exception
      puts exception.message
      puts exception.backtrace
    end
  end
  def pwdHandler(args)
    return unless argsCheck(args, 1, "USAGE: pwd")
    begin
      puts "Working directory: " + Dir.pwd()
    rescue => exception
      puts exception.message
      puts exception.backtrace
    end
  end
  
  def mkdirHandler(args)
    return unless argsCheck(args, 2, "USAGE: mkdir <path>")
    begin
      Dir.mkdir(args[1])
      puts "Created directory " + args[1] + " in " + Dir.pwd()
    rescue Errno::EEXIST
      puts "Directory " + args[1] + " already exists in " + Dir.pwd()
    rescue Errno::ENOENT
      puts "Filepath specified does not exist."
    rescue => exception
      puts exception.message
      puts exception.backtrace
    end
  end
  def rmHandler(args)
    #Removes both files and directories
    return unless argsCheck(args, 2, "USAGE: rm <path>")
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
  def touchHandler(args)
    return unless argsCheck(args, 2, "USAGE: touch <filename>")
    begin
      fileExisted = File.exist?(args[1])
      FileUtils.touch(args[1])
      if fileExisted
        puts "Updated " + args[1] + " in " + Dir.pwd
      else
        puts "Created file " + args[1] + " in " + Dir.pwd
      end
    rescue Errno::ENOENT
      puts "Filepath specified does not exist."
    rescue => exception
      puts exception.message
      puts exception.backtrace
    end
  end
  
  def delayedMessageHandler(args)
    argUsage = "USAGE: delayedMessage <time> <message>"
    return unless argsCheck(args, 3, argUsage)
    pid = Process.fork
    if pid == nil
      # do the delay
      delayedMessage(args[1], args[2])
    else
      Process.detach(pid)
    end
  end
  
  def delayedActionHandler(args)
    argUsage = 'USAGE: delayedAction <time> "<ruby code>"'
    return unless argsCheck(args, 3, argUsage)
    pid = Process.fork
    if pid == nil
      # do the delay
      delayedAction(args[1]) { eval(args[2]) }
    else
      Process.detach(pid)
    end
  end
  
  def self.filewatchHandler(args)
    if args.length < 3
      puts "USAGE: filewatch <mode> <optional time> <filename(s)> \"<command>\""
      return
    end
    args.shift
    mode = args[0]
    files = []
    time = 0;
    block = ""
    args.each_with_index do |a, i|
      if a.match(/\A\d+\z/)
        time = a
      elsif i.between?(1,args.length-2)
        files << a
      elsif i==args.length-1
        block = a
      end
    end

    begin
      pid = Process.fork
      if pid.nil?
        f = FileWatch.new(mode,time,*files) { eval( "lambda {" + block + "}").call }
        f.start
      else
        Process.detach(pid)
      end
    rescue Interrupt
      abort('User terminated watching.')
#    rescue StandardError => e
#      abort('Error in execution: ' + e.to_s)
    end
    
  end
end
