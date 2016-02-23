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
        if !File.exist?(file)
          watch_while { !File.exist?(file)}
        else
          raise "#{file} already exists"
        end
      when 'alter'
        if File.exist?(file)
          current_time = File.mtime(file)
          watch_while { current_time == File.mtime(file) }
        else
          raise "#{file} doesn't exist"
        end
      when 'destroy'
        if File.exist?(file)
          watch_while { File.exist?(file) }
        else
          raise "#{file} doesn't exist"
        end
      else
        raise "#{@mode} mode for file watching not supported\n"
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
      
  