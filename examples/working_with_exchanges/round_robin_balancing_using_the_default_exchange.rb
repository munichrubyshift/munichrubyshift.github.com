#!/usr/bin/env ruby
# encoding: utf-8

require "rubygems"
require "amqp"

EventMachine.run do
  AMQP.connect do |connection|
    channel1  = AMQP::Channel.new(connection)
    channel2  = AMQP::Channel.new(connection)
    exchange = channel1.default_exchange

    q1 = channel1.queue("amqpgem.examples.queues.shared", :auto_delete => true)
    q1.subscribe do |payload|
      puts "Queue #{q1.name} on channel 1 received #{payload}"
    end

    q2 = channel2.queue("amqpgem.examples.queues.shared", :auto_delete => true)
    q2.subscribe do |payload|
      puts "Queue #{q2.name} on channel 2 received #{payload}"
    end

    # Publish some test data in a bit, after queues are declared & bound
    EventMachine.add_timer(0.3) do
      5.times { |i| exchange.publish("Hello #{i}, fanout exchanges world!", :routing_key => "amqpgem.examples.queues.shared") }
    end


    show_stopper = Proc.new { connection.close { EventMachine.stop } }
    Signal.trap "TERM", show_stopper
    EM.add_timer(3, show_stopper)
  end
end
