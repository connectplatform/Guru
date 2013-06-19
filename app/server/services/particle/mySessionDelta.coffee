watcher = config.require 'load/mongoWatch'

module.exports =
  required: ['session']
  service: ({session}, listener) ->
    watcher.watch "#{config.mongo.dbName}.sessions", (event) ->
      listener event if event.targetId is session?._id
