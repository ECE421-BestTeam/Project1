require_relative '../delay/delay'
require_relative 'file-watch-contract'

include ContractFileWatch

class FileWatch

  attr_reader :mode, :time, :files, :threads

  def initialize(type, time=0, *files, &block)
    pre_FileWatch(type, time, *files)
    @mode = type
    @time = time.to_f
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
    @threads.each do |t|
      t.join
    end
    
  end
  
  def watch(file)
    case @mode
      when 'create'
        assert(!File.exist?(file), "#{file} already exists")
        watch_while { !File.exist?(file)}
      when 'alter'
        assert(File.exist?(file), "#{file} doesn't exist")
        current_time = File.mtime(file)
        watch_while { current_time == File.mtime(file) }
      when 'destroy'
        assert(File.exist?(file), "#{file} doesn't exist")
        watch_while { File.exist?(file) }
      else
        printf "#{@mode} mode for file watching not supported\n"
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
    delayedAction(@time) {@block.call}
#    sleep(@time)
#    @block.call
  end


end
      
  