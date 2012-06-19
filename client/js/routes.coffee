define ["dermis"], (dermis) ->
  ###
  dermis.route '/boards'

  dermis.route '/board/:id'
  dermis.route '/board/:id/:page'

  dermis.route '/thread/:id'
  dermis.route '/thread/:id/:post'
  ###

#  dermis.route '/'
  dermis.route '/newChat'
#  dermis.route '/chat/:id'

  dermis.init()
