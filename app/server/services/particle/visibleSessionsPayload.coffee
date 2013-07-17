{Session} = config.require('load/mongo').models

module.exports =
  required: ['session']
  service: ({session}, done) ->
    Session.find {
      accountId: session.accountId
      _id: {$ne: session._id}

    }, (err, sessions=[]) ->

      done err, {data: sessions}
