require 'socket'
require 'xmlrpc/client'
  
module OnlineHelper
  
  def connect
    @connection = XMLRPC::Client.new(@clientSettings.host, nil, @clientSettings.port)
  end
  
  def redirect(newAddress)
    if newAddress.class == String
      add = newAddress.split(':')
      @clientSettings.host = add[0]
      @clientSettings.port = add[1]
    else
      @clientSettings.host = newAddress['host']
      @clientSettings.port = newAddress['port']
    end
    @clientSettings.host = 'localhost' if @clientSettings.host == local_ip
    connect
  end
  
  def handleResponse(responseFn, success = Proc.new {|data|})
    i = 0
    while @busy
      sleep 0.2
      raise IOError, "Can't get turn for #{responseFn}" if i > 50
      i += 1
    end
    @busy = true
    handleResponse2(responseFn, success)
    @busy = false
  end
  
  def handleResponse2(responseFn, success, recur = 0)
    if recur > 5
      raise IOError, "too many redirects"
    end
    response = responseFn.call
    data = response['data']
    case response['status']
      when 'redirect'
        redirect(data)
        handleResponse2(responseFn, success, recur + 1)
      when 'exception'
        exClass = Exception
        begin
          exClass = Object.const_get(data['class'])
        rescue
          # can't get the exception class for some reason
        end
        msg = data['message']
        data['backtrace'].each do |level|
          msg += "\n\t#{level}"
        end
        ex = exClass.new msg
        @busy = false
        raise ex
    when 'ok'
      success.call data
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