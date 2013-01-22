module.exports = (args, next) ->
  config.services['chats/getRelationToChat'] args, (err, {isWatching}) ->
    return next err if err
    return next new Error 'You are not visible in this chat.' unless isWatching is 'false'
    next()
