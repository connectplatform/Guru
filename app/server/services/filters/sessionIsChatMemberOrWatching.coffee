module.exports = (args, next) ->
  config.services['chats/getRelationToChat'] args, (err, {relation}) ->
    return next err if err
    return next 'You are not a member of this chat or watching it.' unless relation in ['Member', 'Watching']
    next()
