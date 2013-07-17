module.exports =
  dependencies:
    services: ['joinChat']
  required: ['sessionId', 'chatId']
  service: (params, done, {services}) ->
    params.relation = 'Watching'
    services['joinChat'] params, done
