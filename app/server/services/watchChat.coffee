module.exports =
  required: ['sessionId', 'chatId']
  service: (params, done) ->
    params.relation = 'Watching'
    config.services['joinChat'] params, done
