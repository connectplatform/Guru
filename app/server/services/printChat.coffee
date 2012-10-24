stoic = require 'stoic'
{Session, Chat} = stoic.models

render = config.require 'services/templates/renderTemplate'

module.exports = (res, chatId) ->
  Session.accountLookup.get res.cookie('session'), (err, accountId) ->
    Chat(accountId).get(chatId).history.all (err, history) ->
      return res.reply err if err?
      res.reply null, render 'chatHistory', history: history
