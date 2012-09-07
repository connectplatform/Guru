module.exports = (chat) ->
  status = chat.relation or chat.status
  ['transfer', 'invite', 'waiting', 'active', 'vacant'].indexOf status
