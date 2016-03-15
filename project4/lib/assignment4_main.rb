require_relative './view/menu'

game = MenuView.new 1, 1

# OR for a cmd interface, you can do
#game = MenuView.new 0, 0

# OR for a cmd menu and gtk board, you can do
#game = MenuView.new 0, 1

# OR for a gtk menu and cmd board, you can do
#game = MenuView.new 1, 0