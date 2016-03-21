require_relative './view/menu'

# for a complete gui interface
game = MenuView.new 1, 1

# OR for a cmd interface, you can do
#game = MenuView.new 0, 0

# OR for a cmd menu and gtk board, you can do
#game = MenuView.new 0, 1

# OR for a gtk menu and cmd board, you can do
#game = MenuView.new 1, 0

#def doThings
#      doThing
#    doThing
#
#end
#
#def doThing
#      a = gets
#    if !a
#      puts 'wow'
#      return
#    end
#    puts 'wowi'
#end
#
#while true
#  puts 'loop'
#  begin 
#    doThings
#  rescue StandardError => e
#    # does not rescue interrupt, but does rescue errors caused by interrupt
#    # like when ctrl+C when the user has some input but hasn't hit enter, it breaks -.-
#    @helper.logError e
#    Process.kill("INT", Process.pid)
#    puts e
#  end
#end
#
