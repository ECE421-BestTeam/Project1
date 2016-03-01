require 'Matrix'

module Regression
  
  def doSomeWork(threads)
    startTime = Time.now
    
    numOfOps = 10000
    opsPerThread = numOfOps/threads
    remain = numOfOps % threads
    ts = []
    
    (0..(threads - 1)).each do |i|
      ts << Thread.new(i) do |n|
        ops = n
        ops += 1 if n <= remain
        (0..(ops - 1)).each do
          Matrix[
            [1,7,8,4,3],
            [5,9,7,3,4],
            [8,6,9,8,7],
            [8,6,9,1,5],
            [2,3,1,4,5]
          ].det
        end
      end
    end
    
    ts.each do |t|
      t.join
    end
    
    endTime = Time.now
    return endTime - startTime
  end

end