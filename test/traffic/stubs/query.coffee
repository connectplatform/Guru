define ['vendor/eventemitter2', 'load/render'], (EventEmitter2, render) ->
  # queryProxyConfigSchema =
  #   'root.path':
  #     get: () -> null
  #     updateUI: (data) -> null

  queryProxyConfig = () ->
    'mySession.unansweredChats':
      get: () =>
        {unansweredChats} = @models.mySession?[0]

      updateUI: ({unansweredChats}) =>
        # AD HOC -- should use a render.* method
        # QUESTION -- do we want to pass a standad DOM node object
        # to the render method, or a jquery selection (e.g. the
        # return value of $(@node).find('.notifyUnanswered')
        $(@node).find('.notifyUnanswered').html unansweredChats

    'mySession.unreadMessages':
      get: () =>
        {unreadMessages} = @models.mySession?[0]

      updateUI: ({unreadMessages}) =>
        $(@node).find('.notifyUnread').html unreadMessages


  class QueryProxy # extends EventEmitter2
    # QUESTION -- wary of all the @-binding. Better patterns?
    constructor: (@node, @collector, Config) ->
      @paths = Config.bind(@)()
      @models = @collector.data

      # QUESTION -- is this how you us bubbling Particle events to
      # UI updates via the proxy?
      @collector.onAny (_, {root, path}) =>
        event = "#{root}.#{path}"
        # console.log 'QueryProxy:', event

        _data = @paths[event]?.get()
        @paths[event]?.updateUI _data if _data?

  return {
    queryProxyConfig
    QueryProxy
  }