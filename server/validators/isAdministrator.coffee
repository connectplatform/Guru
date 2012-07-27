redgoose = require 'redgoose'
{Session} = redgoose.models

module.exports = (req, cb) ->

  sessionId = req.cookies.session
  cb false unless sessionId?

  Session.get(sessionId).role.get (err, role) ->
    cb false if err
    cb role is 'Administrator'
