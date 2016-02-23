# Driver for file watching testing on commandline
# e.g.
# ruby file-watcher.rb --watchCreate -t 5 -r "puts 'watched testfile'" testfile

require 'optparse'
require_relative 'lib/file-watch/file-watch'

options = {}

op = OptionParser.new do |o|
  o.banner = 'Usage: file-watcher.rb --watch<Mode> -t time -r "COMMAND" [filenames seperated by spaces]'
  o.on('--watchCreate', 'Watch for file creation.') { options[:mode] = 'create'}
  o.on('--watchAlter', 'Watch for file alteration.') { options[:mode] = 'alter'}
  o.on('--watchDestroy', 'Watch for file destruction.') { options[:mode] = 'destroy'}
  o.on('-t','--time DELAY','Optional time delay in seconds.') {|d| options[:time] = d}
  o.on('-r', '--run "COMMAND"','Command string performed after delay.') {|c| options[:block] = eval("lambda {" + c + " }") }
  o.on('-h', '--help', 'Display this screen') { puts o; exit }
end

op.parse!(ARGV)

abort("Missing arguments, see -h or --help for usage") if options.empty?

options[:time] = 0 if options[:time].nil?


begin
  pid = Process.fork
  if pid.nil?
    f = FileWatch.new(options[:mode], options[:time], *ARGV) { options[:block].call }
    f.start
  else
    Process.detach(pid)
  end

rescue Interrupt
  abort('User terminated watching.')
rescue StandardError => e
  abort('Error in execution: ' + e.to_s)
end




