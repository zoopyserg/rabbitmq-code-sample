require 'bunny'
require 'ougai'
require_relative 'config/initializers/logger'

class Consumer
  def initialize(queue:)
    @logger = $logger  # Use the global logger
    @connection = Bunny.new(hostname: 'rabbitmq', username: 'guest', password: 'guest')
    @connection.start
    @channel = @connection.create_channel
    @queue = @channel.queue(queue)
    @logger.info("Consumer initialized", queue: queue)
  end

  def start
    @queue.subscribe(block: true) do |delivery_info, properties, payload|
      @logger.info("Received message", payload: payload)
      puts "Received #{payload}"
    end
  rescue => e
    @logger.error("Error in consumer", error: e.message)
  ensure
    @connection.close
    @logger.info("Connection closed")
  end
end
