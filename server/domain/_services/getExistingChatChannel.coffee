pulsar = require '../../pulsar'
redgoose = require 'redgoose'
{Chat, Session} = redgoose.models

module.exports = (res) ->

  Session.get(unescape res.cookie 'session').visitorChat.get (err, userChannel) ->
    return res.send null, channel: userChannel if userChannel?
    res.send null, null