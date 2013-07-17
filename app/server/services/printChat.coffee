db = config.require 'load/mongo'
{Chat} = db.models

module.exports =
  dependencies:
    services: ['templates/renderTemplate']
  required: ['chatId', 'accountId', 'sessionId']
  service: ({chatId, accountId, sessionId}, done, {services}) ->
    render = services['templates/renderTemplate']
    
    Chat.findById chatId, (err, chat) ->
      return done err if err

      html = render {template: 'chatHistory', options: chat}
      done null, {html}
