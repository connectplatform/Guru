module.exports = (pulsar) ->
  ops = pulsar.channel 'notify:operators'

  channels =
    notifyOperators = ops.emit
