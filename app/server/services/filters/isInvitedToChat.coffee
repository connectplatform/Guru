module.exports = (args, next) ->
  config.services['chats/getRelationToChat'] args, (err, {relation}) ->
    return next err if err
    return next new Error 'You are not invited to this chat.' unless relation is 'Invite'
    next()
