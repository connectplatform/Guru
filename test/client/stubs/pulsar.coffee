define ['app/EventEmitter'], (EventEmitter) ->
  channels: {}
  channel: (name) ->
    @channels[name] = new EventEmitter
