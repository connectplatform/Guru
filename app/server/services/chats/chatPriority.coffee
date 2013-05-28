module.exports = (chat) ->
  # status = chat.relation or chat.status
  ['Transfer', 'Invite', 'Waiting', 'Active', 'Vacant'].indexOf chat.status
