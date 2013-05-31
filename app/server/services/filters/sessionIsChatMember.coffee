module.exports = (args, next) ->
  config.services['chats/getRelationToChat'] args, (err, {relation}) ->
    return next err if err
    return next 'You are not a member of this chat.' unless relation is 'Member'
    next()
