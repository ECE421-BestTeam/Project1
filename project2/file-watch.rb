# Driver for file watching

require 'optparse'
require_relative 'lib/file-watch.rb'

options = {}

op = OptionParser.new do |o|
  o.banner = 'Usage: file-watch.rb <flags> <files>'
  o.on('-c', '--create', 'Watch for file creation.') { options[:mode] = 'create'}
  o.on('-a','--alter', 'Watch for file alteration.') { options[:mode] = 'alter'}
  o.on('-d','--destroy', 'Watch for file destruction.') { options[:type] = 'destroy'}
  o.on('-t','--time DELAY',Integer,'Optional time delay in seconds.') {|d| options[:time] = d}
  o.on('-r', '--run "COMMAND"','Command string performed after delay.') {|c| options[:block] = eval("lambda {" + c + " }") }
  o.on('--terminate','Terminate all file watching.') {|e| options[:end]=e}
  o.on('-h', '--help', 'Display this screen') { puts o; exit }
end

op.parse!(ARGV)

if options[:end]
  Process.kill(3, Process.pid)
end

abort("Missing arguments, see -h or --help for usage") if options.empty?

options[:time] = 0 if options[:time].nil?


begin
  p = fork {
    f = FileWatch.new(options[:mode], options[:time], *ARGV) {options[:block].call}
    f.start
  }
  Process.detach(p)


rescue Interrupt
  abort('User terminated watching.')
rescue StandardError => e
  abort('Error executing FileWatch: #{e}')
end

