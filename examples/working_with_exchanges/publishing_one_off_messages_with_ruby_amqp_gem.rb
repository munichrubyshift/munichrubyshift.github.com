require 'rubygems' # or use Bundler.setup
require 'amqp'

puts "=> Publishing and immediately stopping the event loop in the callback"
puts

EventMachine.run do
  connection = AMQP.connect(:host => '127.0.0.1')
  channel    = AMQP::Channel.new(connection)

  # topic exchange is used just as example. Often it is more convenient to use default exchange,
  # see http://bit.ly/amqp-gem-default-exchange
  exchange = channel.topic("a.topic", :durable => true, :auto_delete => true)
  queue    = channel.queue("a.queue", :auto_delete => true).bind(exchange, :routing_key => "events.#")

  exchange.publish('hello world', :routing_key => "events.hits.homepage", :persistent => true, :nowait => false) do
    puts "About to unsubscribe..."
    connection.close { EventMachine.stop }
  end

end
