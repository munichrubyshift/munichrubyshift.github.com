require "rubygems"
require 'amqp'


puts "=> Queue exclusivity violation results "

EventMachine.run do
  connection1 = AMQP.connect("amqp://guest:guest@dev.rabbitmq.com")
  channel1    = AMQP::Channel.new(connection1)

  connection2 = AMQP.connect("amqp://guest:guest@dev.rabbitmq.com")
  channel2    = AMQP::Channel.new(connection2)

  channel1.on_error do |ch, close|
    puts "Handling a channel-level exception on channel1: #{close.reply_text}, #{close.inspect}"
  end
  channel2.on_error do |ch, close|
    puts "Handling a channel-level exception on channel2: #{close.reply_text}, #{close.inspect}"
  end

  name = "amqpgem.examples.queue"
  channel1.queue(name, :auto_delete => true, :exclusive => true)
  # declare a queue with the same name on a different connection
  channel2.queue(name, :auto_delete => true, :exclusive => true)


  EventMachine.add_timer(3.5) do
    connection1.close {
      connection2.close {
        EventMachine.stop { exit }
      }
    }
  end
end
