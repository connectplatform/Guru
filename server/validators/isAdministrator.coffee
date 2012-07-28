redgoose = require 'redgoose'
{Session} = redgoose.models

module.exports = (args, cookies, cb) ->

  sessionId = cookies.session
  cb false unless sessionId?

  Session.get(sessionId).role.get (err, role) ->
    cb false if err
    cb role is 'Administrator'
