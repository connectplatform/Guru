stoic = require 'stoic'
{Session, Chat} = stoic.models

module.exports = (res, id) ->
  Session.accountLookup.get res.cookie('session'), (err, accountId) ->
    Chat(accountId).get(id).history.all (err, history) ->
      if err
        config.log.error 'Error recovering history for chat', {error: err, chatId: id, history: history}
        res.reply 'could not find chat'
      else
        res.reply null, history
