module.exports =
  service: (params, done) ->
    params.isWatching = 'true'
    config.services['joinChat'] params, done
