
class CmdHelper
  
  def initialize(exitCallback)
    @exitCallback = exitCallback
  end

  def logError (e)
    puts e
  end
  
  # question - string that is printed
  # answers - an array of valid answers
  # callback - called with a valid answer
  # recursive - boolean used to indicate if this is a recursive call
  def getUserInput(question, answers, callback, recursive = false)
    puts question
    
#    begin
    ans = gets.strip
#    rescue StandardError => e
#      raise e
#    rescue Interrupt
#      puts 'int'
#    end
    
    # only wrap the callback on the first call
    if !recursive
      ocb = callback
      callback = Proc.new do |res|
        begin
          ocb.call(res)
        rescue Exception => e
          errorHandler(e)
          getUserInput(question, answers, callback, true)
        end
      end
    end
    
    if ans == "exit"
      @exitCallback.call
      puts "helper #{@gameover} gmover"
    elsif answers.include?(ans)
      callback.call(ans)
    elsif is_integer?(ans) && answers.include?(Integer(ans))
      callback.call(Integer(ans))
    else
      puts "Invalid.  Should be one of: #{answers}"
      getUserInput(question, answers, callback, true)
    end
  end
  
  def errorHandler(err)
    puts err.to_s
  end
  
  def is_integer?(n)
    true if Integer(n) rescue false
  end
  
end