async = require 'async'
stoic = require 'stoic'
{Chat} = stoic.models

module.exports = (res) ->
  async.parallel {
    all: Chat.allChats.all
    unanswered: Chat.unansweredChats.all

  }, res.reply
