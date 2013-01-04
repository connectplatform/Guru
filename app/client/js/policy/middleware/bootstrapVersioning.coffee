define ["helpers/util"], (util) ->
  (args, next) ->

    # Version A is for operator dashboard, B is for visitor chat
    versionA = $('.bs-203')
    versionB = $('.bs-222')

    # We want to remove versionA no matter what
    versionA.remove()

    # We also want to hide the sidebar to
    # style the visitor chat nicely
    $('#sidebar').css 'display', 'none'

    if versionB.length > 0
      
      # If it has already been loaded, next
      return next null, args

    else if versionB.length is 0

      # load the other bootstrap
      util.loadResource
        file: 'js/vendor/bootstrap-2.2.2.js'
        type: 'js'
        className: 'bs-222'
      util.loadResource
        file: 'css/vendor/bootstrap-2.2.2.min.css'
        type: 'css'
        className: 'bs-222'
      util.loadResource
        file: 'css/vendor/bootstrap-responsive-2.2.2.min.css'
        type: 'css'
        className: 'bs-222'

      next null, args
