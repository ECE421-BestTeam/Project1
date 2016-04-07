require 'socket'
require 'xmlrpc/client'
  
module OnlineHelper
  
  def connect
    close
    @connection = XMLRPC::Client.new(@clientSettings.host, nil, @clientSettings.port)
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
        exClass = Exception
        begin
          exClass = Object.const_get(response['data']['class'])
        rescue
          # can't get the exception class for some reason
        end
        msg = response['data']['message']
        response['data']['backtrace'].each do |level|
          msg += "\n\t#{level}"
        end
        ex = exClass.new msg
        raise ex
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