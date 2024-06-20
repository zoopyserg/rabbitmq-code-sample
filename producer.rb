require 'bunny'
require 'ougai'
require_relative 'config/initializers/logger'

class Producer
  def initialize(queue:)
    @logger = $logger  # Use the global logger

    begin
      @connection = Bunny.new(hostname: 'rabbitmq', username: 'guest', password: 'guest')
      @connection.start
      @channel = @connection.create_channel
      @queue = @channel.queue(queue)
      @logger.info("Producer initialized", queue: queue)
    rescue Bunny::TCPConnectionFailed => e
      @logger.error("Failed to connect to RabbitMQ", error: e.message)
      raise
    end
  end

  def publish(payload)
    @channel.default_exchange.publish(payload, routing_key: @queue.name)
    @logger.info("Message published", payload: payload)
  ensure
    @connection.close if @connection && @connection.open?
    @logger.info("Connection closed")
  end
end
