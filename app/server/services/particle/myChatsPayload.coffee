module.exports =
  required: ['sessionSecret', 'sessionId']
  service: ({sessionSecret, sessionId}, done) ->
    config.services['operator/getChatMembership'] {sessionSecret, sessionId}, (err, {chatIds}) ->
      return done err if err

      config.services['chats/getChats'] {chatIds}, (err, {chats}) ->
        done err, {data: chats}
