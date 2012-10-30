joinChat = config.require 'services/joinChat'

module.exports =
  service: (params, done) ->
    params.isWatching = true
    joinChat params, done
