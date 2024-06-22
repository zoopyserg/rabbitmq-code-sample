require 'bunny'
require 'ougai'
require 'prometheus/client'
require 'prometheus/client/formats/text'
require 'webrick'
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
      Consumer.increment_message_count
      puts "Received #{payload}"
    end
  rescue => e
    @logger.error("Error in consumer", error: e.message)
  ensure
    @connection.close
    @logger.info("Connection closed")
  end

  # Define a class method to increment the message count
  def self.increment_message_count
    @@message_count.increment(labels: { app: 'consumer' })
  end
end

# Create a new registry
prometheus = Prometheus::Client.registry

# Define a new counter metric
@@message_count = Prometheus::Client::Counter.new(:consumer_messages_total, docstring: 'A counter of messages processed by the consumer', labels: [:app])
prometheus.register(@@message_count)

# Start the consumer in a separate thread
Thread.new do
  consumer = Consumer.new(queue: 'tasks')
  consumer.start
end

# Define the Rack application for the metrics endpoint
class MetricsApp
  def call(env)
    [
      200,
      { 'Content-Type' => Prometheus::Client::Formats::Text::CONTENT_TYPE },
      [Prometheus::Client::Formats::Text.marshal(Prometheus::Client.registry)]
    ]
  end
end

# Start the WEBrick server to serve metrics
server = WEBrick::HTTPServer.new(Port: 9394)
server.mount '/metrics', MetricsApp
trap 'INT' do
  server.shutdown
end
server.start
