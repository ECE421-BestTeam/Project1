require_relative './lib/client/view/cmd/view'
require_relative './lib/client/view/gtk/view'

if ARGV.size != 1
  puts "Please enter 1 parameter, either gtk or cmd for GUI or console view"
else
  case ARGV[0]
  when 'gtk'
    GtkView.new
  when 'cmd'
    CmdView.new
  else
    puts "Please enter either gtk or cmd for GUI or console view"
  end
end