define ["dermis"], (dermis) ->
#  dermis.route '/'
  dermis.route '/newChat'
  dermis.route '/chat/:id'

  dermis.init()
