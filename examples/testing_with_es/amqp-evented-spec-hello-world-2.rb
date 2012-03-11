require 'spec_helper'
require 'evented-spec'

describe "Hello, world! example" do
  include EventedSpec::AMQPSpec

  default_options :vhost => "amqp_testing_vhost"
  default_timeout 1

  it "should pass" do
    done
  end
end
