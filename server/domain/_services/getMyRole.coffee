redgoose = require 'redgoose'
{Session} = redgoose.models

module.exports = (res) ->
  sessID = res.cookie 'session'
  Session.get(sessID).role.get res.send
