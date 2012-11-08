module.exports =
  service: (params, done) ->
    # TODO: putting config.service at the top of a file causes a load to be attempted before services are defined
    joinChat = config.service 'joinChat'
    params.isWatching = 'true'
    joinChat params, done
