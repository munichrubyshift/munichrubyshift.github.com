require 'spec_helper'

describe "Topic-based subscription" do
  include EventedSpec::AMQPSpec
  default_timeout 1

  amqp_before do
    # initializing amqp channel
    @channel   = AMQP::Channel.new
    # using default amqp exchange
    @exchange = @channel.topic
  end

  context "when key matches on # (multiple words globbing)" do
    it "routes messages to bound queues" do
      # Setting up queues
      @sports_queue  = @channel.queue("Sports queue", :auto_delete => true)
      @nba_queue     = @channel.queue("NBA queue", :auto_delete => true)
      @knicks_queue  = @channel.queue("New York Knicks queue", :auto_delete => true)
      @celtics_queue = @channel.queue("Boston Celtics queue", :auto_delete => true)

      received_messages = {
        @sports_queue.name  => 0,
        @nba_queue.name     => 0,
        @knicks_queue.name  => 0,
        @celtics_queue.name => 0
      }

      expected_messages = {
        @sports_queue.name  => 9,
        @nba_queue.name     => 7,
        @knicks_queue.name  => 2,
        @celtics_queue.name => 3
      }

      @sports_queue.bind(@exchange, :key => "sports.#").subscribe do |payload|
        received_messages[@sports_queue.name] += 1
      end

      @nba_queue.bind(@exchange, :key => "*.nba.*").subscribe do |payload|
        received_messages[@nba_queue.name] += 1
      end

      @knicks_queue.bind(@exchange, :key => "sports.nba.knicks").subscribe do |payload|
        received_messages[@knicks_queue.name] += 1
      end

      @celtics_queue.bind(@exchange, :key => "#.celtics").subscribe do |payload|
        received_messages[@celtics_queue.name] += 1
      end

      @exchange.publish("Houston Rockets 104 : New York Knicks 89", :key => "sports.nba.knicks")
      @exchange.publish("Phoenix Suns 129 : New York Knicks 121", :key => "sports.nba.knicks")

      @exchange.publish("Ray Allen hit a 21-foot jumper with 24.5 seconds remaining on the clock to give Boston a win over Detroit last night in the TD Garden", :key => "sports.nba.celtics")
      @exchange.publish("Garnett's Return Sparks Celtics Over Magic at Garden", :key => "sports.nba.celtics")
      @exchange.publish("Tricks of the Trade: Allen Reveals Magic of Big Shots", :key => "sports.nba.celtics")

      @exchange.publish("Blatche, Wall lead Wizards over Jazz 108-101", :key => "sports.nba.jazz")
      @exchange.publish("Deron Williams Receives NBA Cares Community Assist Award", :key => "sports.nba.jazz")

      @exchange.publish("Philadelphia's Daniel Briere has been named as an All-Star replacement for Jarome Iginla.", :key => "sports.nhl.allstargame")
      @exchange.publish("Devils blank Sid- and Malkin-less Penguins 2-0", :key => "sports.nhl.penguins")

      # Using #done with argument invokes done after a delay given in argument
      done(0.2) {
        # After #done is invoked, it launches an optional callback

        # Here goes the main check
        received_messages.should == expected_messages
      }
    end # it
  end # context
end # describe
