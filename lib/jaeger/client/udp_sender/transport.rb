module Jaeger
  module Client
    class UdpSender
      class Transport
        FLAGS = 0

        def initialize(host, port)
          @socket = UDPSocket.new
          @socket.connect(host, port)
          @buffer = ::Thrift::MemoryBufferTransport.new
        end

        def write(str)
          @buffer.write(str)
        end

        def flush
          data = @buffer.read(@buffer.available)
          send_bytes(data)
        end

        def open; end

        def close; end

        private

        def send_bytes(bytes)
          @socket.send(bytes, FLAGS)
          @socket.flush
        rescue Errno::ECONNREFUSED
          warn 'Unable to connect to Jaeger Agent'
        rescue StandardError => e
          warn "Unable to send spans: #{e.message}"
        end
      end
    end
  end
end
