require 'socket'
require 'xmlrpc/client'
  
module OnlineHelper
  
  def connect
    close
    @connection = XMLRPC::Client.new(@clientSettings.host, nil, @clientSettings.port)
    @clientSettings.save
  end
  
  def close
    if @connection
      handleResponse(
        @connection.call('close')
      )
    end
  end
  
  def redirect(newAddress)
    @clientSettings.serverAddress = newAddress
    connect
  end
  
  def handleResponse(response, success = Proc.new {|data|}, postRedirect = Proc.new {})
    case response['status']
      when 'redirect'
        redirect(response.data)
        postRedirect.call
      when 'exception'
        raise response['data']
    when 'ok'
      success.call response['data']
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