{removalEvent} = config.require 'lib/eventConstructors'
watcher = config.require 'load/mongoWatch'
logger = config.require 'lib/logger'

Queue = require 'queue'
{curry} = config.require 'lib/util'

module.exports =
  required: ['session']
  service: (identity, listener) ->
    watcher.watch "#{config.mongo.dbName}.sessions", (event) ->

      event = event.clone()
      event.oplist = event.oplist.filter (op) -> op.id isnt identity?.session?._id
      if event.oplist.length > 0
        listener(event)
