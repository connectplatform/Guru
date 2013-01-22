module.exports = (args, next) ->
  config.services['chats/getRelationToChat'] args, (err, {relationType}) ->
    return next err if err
    return next 'You are not a member of this chat.' unless relationType is 'member'
    next()
