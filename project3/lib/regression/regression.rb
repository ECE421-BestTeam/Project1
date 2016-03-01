
module Regression
  
  def doSomeWork(threads)
    numOfOps = 10000
    opsPerThread = numOfOps/threads
    remain = numOfOps % threads
    threads.each do |i|
      t = Thread.new(i) do |n|
        ops = n
        ops += 1 if n <= remain
          
      end
    end
  end

end