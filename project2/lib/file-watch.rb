#require_relative './delay/ext/delay.rb'

class FileWatch

  attr_reader :mode, :time, :files, :threads

  def initialize(type, time=0, *files, &block)
    # assuming file types are as follows:
    @mode = type # string
    @time = time #* 1000 # milliseconds
    @files = [] # strings
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
    #delay
#    C_Delay.delay(@time)
    sleep(@time)
    @block.call
  end


end
      
  