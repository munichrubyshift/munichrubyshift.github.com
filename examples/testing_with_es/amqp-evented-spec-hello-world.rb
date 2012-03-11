require 'spec_helper'
require 'evented-spec'

describe "Hello, world! example" do
  include EventedSpec::AMQPSpec

  it "should pass" do
    done
  end
end
