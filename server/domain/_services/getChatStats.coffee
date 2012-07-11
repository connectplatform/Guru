async = require 'async'
redgoose = require 'redgoose'
{Chat} = redgoose.models

module.exports = (res) ->
  async.parallel {
    all: Chat.allChats.all
    unanswered: Chat.unansweredChats.all

  }, res.send
