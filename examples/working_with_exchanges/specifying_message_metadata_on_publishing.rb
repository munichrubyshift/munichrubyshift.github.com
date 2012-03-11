exchange.publish("Hey, what a great view!",
                 :app_id         => "amqpgem.example",
                 :priority       => 8,
                 :type           => "kinda.checkin",
                 :correlation_id => "b907b65a4876fc0d4b12fbdef1b41fb0a9876a94",
                 # headers table keys can be anything
                 :headers        => {
                   :coordinates => {
                     :latitude  => 59.35,
                     :longitude => 18.066667
                   },
                   :participants => 11,
                   :venue        => "Stockholm"
                 },
                 :timestamp   => Time.now.to_i,
                 :routing_key => "amqpgem.key")
