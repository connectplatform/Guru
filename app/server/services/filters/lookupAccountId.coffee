{Session, Website} = config.require('load/mongo').models

module.exports =
  required: ['sessionSecret', 'websiteId']
  service: ({sessionSecret, websiteId}, found) ->
    return found() unless sessionSecret or websiteId

    if sessionSecret
      Session.findOne {sessionSecret}, {accountId: 1}, (err, session) ->
        found err, {accountId: session?.accountId}

    else if websiteId
      Website.findById websiteId, {accountId: 1}, (err, website) ->
        found err, {accountId: website?.accountId}
