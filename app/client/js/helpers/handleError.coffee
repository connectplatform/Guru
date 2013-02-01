define ["load/notify"], (notify) ->
  (error, context) ->
    return unless error

    console.log 'Service returned error:', error, 'with context:', context

    rootCause =
      switch context.reason
        when 'requiredField'
          if context.fieldName in ['sessionId', 'accountId']
            $.cookies.del 'session'
            'You are not logged in.'

          else
            "#{context.fieldName} is required."

        when 'invalidValue'
          if context.fieldName in ['sessionId', 'accountId']
            $.cookies.del 'session'
            'Your session has expired.  Please log in again.'

          else
            "#{context.fieldName} is invalid."

        else
          null

    notify.error rootCause if rootCause
