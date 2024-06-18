require 'bunny'

class Consumer
  def initialize(queue:)
    @connection = Bunny.new
    @connection.start
    @channel = @connection.create_channel
    @queue = @channel.queue(queue)
  end

  def start
    @queue.subscribe(block: true) do |delivery_info, properties, payload|
      puts "Received #{payload}"
    end
  end
end

Consumer.new(queue: 'tasks').start
puts 'Consumer started'

loop { sleep 3 }


