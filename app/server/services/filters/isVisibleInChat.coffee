module.exports = (args, next) ->
  config.services['chats/getRelationToChat'] args, (err, {relation}) ->
    return next err if err
    return next new Error 'You are not visible in this chat.' if relation is 'Watching'
    next()
