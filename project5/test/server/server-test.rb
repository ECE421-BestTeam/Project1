require 'test/unit'
require_relative '../../lib/server/server'
require 'socket'

class ServerTest < Test::Unit::TestCase
  
  def setup
    @port = 4222
    # start server
    @th = Thread.new {
      @server = Server.new(@port)
    }
    # connect to server
    @s = TCPSocket.open('localhost', @port)
    assert_equal "ok", @s.gets.chomp
  end

  def teardown
    @s.close
    @th.kill # kills the server thread
    @th.join
  end
  
  def test_createPlayer
    @s.puts "createPlayer"
    res = @s.gets.chomp
    assert_equal String, res.class
  end
 
  
end