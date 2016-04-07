require 'socket'
require 'xmlrpc/client'
  
module OnlineHelper
  
  def connect
    close
    @connection = XMLRPC::Client.new(@clientSettings.serverAddress)
    @clientSettings.save
  end
  
  def close
    @connection.close
  end
  
  def redirect(newAddress)
    @clientSettings.serverAddress = newAddress
    connect
  end
  
  def handleResponse(response, success = Proc.new {|data|}, postRedirect = Proc.new {})
    case response.status
      when 'redirect'
        redirect(result.data)
        postRedirect.call
      when 'exception'
        raise result.data.type, result.data.msg
    when 'ok'
      success.call result.data      
    end
  end
  
  def local_ip
    orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true  # turn off reverse DNS resolution temporarily

    UDPSocket.open do |s|
      s.connect '64.233.187.99', 1
      s.addr.last
    end
  ensure
    Socket.do_not_reverse_lookup = orig
  end
  
end