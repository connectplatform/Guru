module.exports = (args, next) ->
  config.services['chats/getRelationToChat'] args, (err, {relationType}) ->
    return next err if err
    return next new Error 'You are already a member of this chat.' if relationType is 'member'
    next()
