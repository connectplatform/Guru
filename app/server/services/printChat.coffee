stoic = require 'stoic'
{Chat} = stoic.models

render = config.require 'services/templates/renderTemplate'

module.exports = (res, chatId) ->
  Chat.get(chatId).history.all (err, history) ->
    return res.reply err if err?
    res.reply null, render 'chatHistory', history: history
