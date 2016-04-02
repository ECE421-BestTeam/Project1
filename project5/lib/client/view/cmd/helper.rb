
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
    
    ans = gets while !ans # sometimes gets gets messed up because of interrupt
    ans = ans.strip
    
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
    elsif validAnswer(answers, ans)
      callback.call(ans)
    else
      puts "Invalid.  Should be one of: #{answers}"
      getUserInput(question, answers, callback, true)
    end
  end
  
  def validAnswer(validAnswers, answer)
    validAnswers.each do |pattern|
      return true if pattern.match(answer)
    end
    return false
  end
  
  def errorHandler(err)
    puts err.to_s
  end
  
end