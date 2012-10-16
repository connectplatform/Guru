define ['templates/imageTemplate'], (image) ->
  (url, selector) ->
    embedImage = ->
      $(selector).html image source: url

    $.ajax {
      type: 'GET'
      async: true
      url: url
      success: embedImage
      error: ->
        #server.serverLog 'error getting image'
    }