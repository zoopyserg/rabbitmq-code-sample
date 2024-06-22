require 'sinatra'
require 'prometheus/client'
require 'prometheus/middleware/exporter'
require 'prometheus/middleware/collector'
require_relative 'config/initializers/logger'
require_relative 'producer'

class App < Sinatra::Base
  # Create a new registry
  prometheus = Prometheus::Client.registry

  # Define a new counter metric
  @@request_count = Prometheus::Client::Counter.new(:http_requests_total, docstring: 'A counter of HTTP requests made', labels: [:app])
  prometheus.register(@@request_count)

  use Prometheus::Middleware::Collector
  use Prometheus::Middleware::Exporter

  before do
    @@request_count.increment(labels: { app: 'web' })
  end

  get '/produce' do
    producer = Producer.new(queue: 'tasks')
    producer.publish('Hello, World!')
    "Message sent to the queue!"
  end
end

run App
