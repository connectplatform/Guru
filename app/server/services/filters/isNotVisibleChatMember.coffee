module.exports = (args, next) ->
  config.services['chats/getRelationToChat'] args, (err, {relation}) ->
    return next err if err
    if relation is 'Member'
      return next new Error 'You are already a visible member of this chat.'
    next()
