{inspect} = require 'util'

module.exports = (args...) ->
  msgs = args.map (a) ->
    if (typeof a) is 'string' then a else inspect a, null, null
  #msgs = msgs.map (m) -> m.blue

  console.log msgs...
