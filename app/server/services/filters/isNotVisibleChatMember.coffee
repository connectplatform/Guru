module.exports = (args, next) ->
  config.services['chats/getRelationToChat'] args, (err, {relationType, isWatching}) ->
    return next err if err
    if relationType is 'member' and isWatching isnt 'true'
      return next new Error 'You are already a visible member of this chat.'

    next()
