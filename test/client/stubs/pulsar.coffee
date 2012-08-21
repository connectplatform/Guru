define ['app/EventEmitter'], (EventEmitter) ->
  pulsar =
    channels: {}
    channel: (name) ->
      @channels[name] ?= new EventEmitter

  window.pulsar = pulsar
  return pulsar
