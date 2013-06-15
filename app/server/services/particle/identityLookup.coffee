{Session} = config.require('load/mongo').models

module.exports =
  required: ['sessionSecret']
  service: ({sessionSecret}, done) ->
    Session.findOne {secret: sessionSecret}, (err, session) ->
      done err, session
