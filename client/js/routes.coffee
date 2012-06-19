define ["dermis"], (dermis) ->
#  dermis.route '/'
  dermis.route '/newChat'
  dermis.route '/visitorChat/:id'

  dermis.init()
