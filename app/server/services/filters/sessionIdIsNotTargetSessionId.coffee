module.exports =
  required: ['sessionId', 'targetSessionId']
  service: (args, next) ->
    {sessionId, targetSessionId} = args
  
    err = new Error 'sessionId and targetSessionId cannot be the same.'
    errCond = (sessionId is targetSessionId)
    return next err if (sessionId == targetSessionId)

    next null, args