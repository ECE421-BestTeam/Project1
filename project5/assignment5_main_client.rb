require_relative './lib/client/view/menu'

# for a complete gui interface
#game = MenuView.new :menuGtk, :boardGtk

# OR for a cmd interface, you can do
game = MenuView.new :menuCmd, :boardCmd

# OR for a cmd menu and gtk board, you can do
#game = MenuView.new :menuCmd, :boardGtk

# OR for a gtk menu and cmd board, you can do
#game = MenuView.new :menuGtk, :boardCmd

