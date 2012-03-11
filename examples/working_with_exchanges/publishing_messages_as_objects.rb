class Message

  #
  # API
  #

  # ...

  def to_s
    # returns textual or binary representation of the message as a String instance
  end

  # ...
end

exchange.publish(Message.new)
