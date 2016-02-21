# Driver for file watching

require 'optparse'
require_relative 'file-watch/file-watch'

options = {}

op = OptionParser.new do |o|
  o.banner = 'Usage: file-watch.rb <watchMode> <flags> <files>'
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
  pid = fork {
    f = FileWatch.new(options[:mode], options[:time], *ARGV) {options[:block].call}
    f.start

  }
  Process.detach(pid)

rescue Interrupt
  abort('User terminated watching.')
rescue StandardError => e
  abort('Error in watch execution: #{e.to_s}')
end

