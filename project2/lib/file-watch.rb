require_relative './delay'

class FileWatch

  attr_reader :type, :time, :files, :threads

  def initialize(type, time=0, *files, &block)
    # assuming file types are as follows:
    @type = type # string
    @time = time #* 1000 # milliseconds
    @files = [] # strings
    files.each do |f|
      @files << f
    end
    @block = block
    @threads = []
  end
  
  def start
    @files.each_with_index do |f, i|
      t = Thread.new{self.run(f)}
      @threads << t
    end
  end
  
  def run(file)
    case @type
      when 'create'
        if !File.exist?(file)
          puts "watching for creation of #{file}"
          watch_while { !File.exist?(file)}
        else
          raise "#{@file} already exists."
        end
      when 'alter'
        if File.exist?(file)
          current_time = File.mtime(file)
          watch_while { current_time == File.mtime(file) }
        else
          raise "File doesn't exist."
        end
      when 'destroy'
        if File.exist?(file)
          watch_while { File.exist?(file) }
        else
          raise "#{@file} does not exist."
        end
      else
        raise "#{@type} mode for file watching not supported"
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
    #return if @threads[thread_index].alive?
    #delay
#    delay(@time) { @block.call }
#    puts "running block #{block}"
    sleep(@time)
    @block.call
  end


end
      
  