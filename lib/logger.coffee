{inspect} = require 'util'
curry = (fn, args...) -> fn.bind fn.prototype, args...

log = (color, args...) ->
  msgs = args.map (a) ->
    if (typeof a) is 'string' then a else inspect a, null, null

  if ''[color]
    msgs = msgs.map (m) -> m[color]

  console.log msgs...

logger = curry log, null

for color in ['white', 'grey', 'black', 'blue', 'cyan', 'green', 'magenta', 'red', 'yellow']
  logger[color] = curry log, color

module.exports = logger
