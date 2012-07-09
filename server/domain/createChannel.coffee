{tandoor} = require '../../lib/util'
redgoose = require 'redgoose'

module.exports = tandoor (serviceName, veinServer, cb)->
  unless veinServer.services[serviceName]?
    veinServer.add serviceName, (res, message)->

      {Session, Chat} = redgoose.models

      sessionId = unescape(res.cookie('session'))
      Session.get(sessionId).chatName.get (err, username)->

        return res.send err if err?
        data =
          message: message
          username: username
          timestamp: Date.now()

        Chat.get(serviceName).history.add data, (err)->
          return res.send err if err?

        res.publish null, data
        res.send null, "ack"

    cb()
