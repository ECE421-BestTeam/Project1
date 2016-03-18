
module CmdHelper
  
   
  # question - string that is printed
  # answers - an array of valid answers
  # callback - called with a valid answer
  # recursive - boolean used to indicate if this is a recursive call
  def self.getUserInput(question, answers, callback, recursive = false)
    puts question
    ans = gets.strip
    
    # only wrap the callback on the first call
    if !recursive
      ocb = callback
      callback = Proc.new do |res|
        begin
          ocb.call(res)
        rescue Exception => e
          self.errorHandler(e)
          raise e
          self.getUserInput(question, answers, callback, true)
        end
      end
    end
    
    if ans == "exit"
      exit
    elsif answers.include?(ans)
      callback.call(ans)
    elsif self.is_integer?(ans) && answers.include?(Integer(ans))
      callback.call(Integer(ans))
    else
      puts "Invalid.  Should be one of: #{answers}"
      getUserInput(question, answers, callback, true)
    end
  end
  
  def self.errorHandler(err)
    puts err.to_s
  end
  
  def self.is_integer?(n)
    true if Integer(n) rescue false
  end
  
end