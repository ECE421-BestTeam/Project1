
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
    elsif (a = validAnswer(answers, ans))[0]
      callback.call(a[1])
    else
      puts "Invalid.  Should be one of: #{answers}"
      getUserInput(question, answers, callback, true)
    end
  end
  
  def validAnswer(validAnswers, answer)
    validAnswers.each do |validAns|
      if validAns.class == String
        return [true, answer] if validAns == answer
      elsif validAns.class == Regexp
        a = pattern.match(answer)
        return [true, a] if a
      elsif validAns.class == Fixnum
        begin
          a = Integer(answer)
          return [true, a] if validAns == a
        rescue ArgumentError
        end
      elsif validAns.class == Float
        begin
          a = Float(answer)
          return [true, a] if validAns == a
        rescue ArgumentError
        end
      end
    end
    return [false]
  end
  
  def errorHandler(err)
    puts err.to_s
  end
  
end