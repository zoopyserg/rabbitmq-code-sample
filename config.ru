require 'sinatra'
require_relative 'config/initializers/logger'
require_relative 'producer'

class App < Sinatra::Base
  get '/produce' do
    producer = Producer.new(queue: 'tasks')
    producer.publish('Hello, World!')
    "Message sent to the queue!"
  end
end

run App
