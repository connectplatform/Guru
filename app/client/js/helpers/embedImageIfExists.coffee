define ['templates/imageTemplate'], (image) ->
  (url, selector) ->
    console.log 'entered embedImageIfExists'
    embedImage = ->
      $(selector).html image source: url

    $.ajax {
      type: 'GET'
      async: true
      url: url
      success: embedImage
      error: ->
        console.log 'error getting image'
      complete: ->
        console.log 'ajax completed'
    }
