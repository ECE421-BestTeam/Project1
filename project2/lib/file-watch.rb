require_relative './delay'

class FileWatch

  def initialize(type, duration=0, *files, &block)
    # assuming file types are as follows:
    @type = type # string
    @duration = duration * 1000 # milliseconds
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
    puts "running #{file}"
    puts "type #{@type}"
    case @type
      when 'create'
        if !File.exist?(file)
          puts 'watching for creation of #{file}}'
          watch_while { !File.exist?(file)}
        end
      when 'alter'
        if File.exist?(file)
          current_time = File.mtime(file)
          watch_while { current_time == File.mtime(file) }
        end
      when 'destroy'
        if File.exist?(file)
          watch_while { File.exist?(file) }
        end
      else
        raise "#{@type} mode for file watching not supported"
      end
  end
  
#  def stop
#    @threads.each do |t|
#      t.terminate
#    end
#  end

  def watch_while(&condition)
    sleep(0) while condition.call
    #return if @threads[thread_index].alive?
    #delay
    delay(@duration) { @block.call }
  end


end
      
  