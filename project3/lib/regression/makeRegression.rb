require './regression.rb'

include Regression

if ARGV.length < 1
  puts "USAGE: maekRegression.rb <output filename(s)>"
elsif ARGV.length == 1
  File.open(ARGV[0], 'w'){|file|
    (1..100).each{|thread_count|
       file.puts("#{thread_count},#{doSomeWork(thread_count)}")
    }
  }
end