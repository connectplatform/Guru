joinChat = config.require 'services/joinChat'

module.exports = (params, done) ->
  params.isWatching = true
  joinChat params, done
