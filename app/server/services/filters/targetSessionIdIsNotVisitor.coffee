db = config.require 'load/mongo'
{Session} = db.models

module.exports =
  required: ['targetSessionId']
  service: (args, next) ->
    {targetSessionId} = args

    Session.findById targetSessionId, (err, session) ->
      return next err if err
      
      noSessionErr = new Error 'No Session exists with targetSessionId'
      return next noSessionErr unless session
  
      isVisitorErr = new Error 'targetSessionId cannot refer to a Visitor'
      return next isVisitorErr unless session?.userId

      next null, args