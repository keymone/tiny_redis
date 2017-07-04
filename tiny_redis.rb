# Copyright 2017 Maksym Melnychok
# MIT License - https://opensource.org/licenses/MIT
#
# inspired by https://github.com/ptrofimov/tinyredisclient

require 'socket'

class TinyRedis
  RN = "\r\n"

  def initialize(host='localhost', port=6379)
    @socket = TCPSocket.new(host, port)
  end

  def method_missing(method, *args)
    args.unshift method
    data = ["*#{args.size}", *args.map {|arg| "$#{arg.to_s.size}#{RN}#{arg}"}]
    @socket.write(data.join(RN) << RN)
    parse_response
  end

  def parse_response
    case line = @socket.gets
    when /^\+(.*)\r\n$/ then $1
    when /^:(\d+)\r\n$/ then $1.to_i
    when /^-(.*)\r\n$/  then raise "Redis error: #{$1}"
    when /^\$([-\d]+)\r\n$/
      $1.to_i >= 0 ? @socket.read($1.to_i+2)[0..-3] : nil
    when /^\*([-\d]+)\r\n$/
      $1.to_i > 0 ? (1..$1.to_i).inject([]) { |a,_| a << parse_response } : nil
    end
  end
  
  def close
    @socket.close
  end
end
