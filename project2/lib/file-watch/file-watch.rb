require_relative '../delay/delay'
require_relative 'file-watch-contract'

include ContractFileWatch

class FileWatch

  attr_reader :mode, :time, :files, :threads

  def initialize(type, time=0, *files, &block)
    pre_FileWatch(type, time, *files)
    @mode = type
    @time = time.to_i
    @files = []
    files.each do |f|
      @files << f
    end
    @block = block
    @threads = []
  end
  
  def start
    @files.each do |f|
      t = Thread.new{watch(f)}
      @threads << t
      
    end
    
  end
  
  def watch(file)
    case @mode
      when 'create'
        if (!File.exist?(file))
          watch_while { !File.exist?(file)}
        else
          puts "#{file} already exists."
        end
      when 'alter'
        if File.exist?(file)
          current_time = File.mtime(file)
          watch_while { current_time == File.mtime(file) }
        else
          puts "File doesn't exist."
        end
      when 'destroy'
        if File.exist?(file)
          watch_while { File.exist?(file) }
        else
          puts "#{file} does not exist."
        end
      else
        puts "#{@mode} mode for file watching not supported"
      end
  end
  
  def stop
    @threads.each do |t|
      t.terminate
    end
    puts 'terminated all'
  end
  
  def watching?
    @threads.each do |t|
      return true if t.alive?
    end
    return false
  end

  def watch_while(&condition)
    sleep(0) while condition.call
    puts "i'm not sleeping!"
    #delay
    delayedAction(@time) {@block.call}
#    sleep(@time)
#    @block.call
  end


end
      
  