define ["vendor/jquery"], ($) ->
  api = {
    configure: (configFileUrl) ->
      deferred = $.Deferred()

      $.ajax {
        url: configFileUrl,
        complete: (data) ->
          $.extend(api, data)
          deferred.resolve()
        error: (err) ->
          console.log "Config error:", err
          deferred.reject()
      }

      return deferred.promise()
  }

  return api