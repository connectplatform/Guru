define ['vendor/eventemitter2', 'load/render'], (EventEmitter2, render) ->
  queryProxyConfig = () ->
    'mySession.unansweredChats':
      get: () =>
        {unansweredChats} = @models.mySession?[0]

      updateUI: ({unansweredChats}) =>
        $(@node).find('.notifyUnanswered').html unansweredChats

    'mySession.unreadMessages':
      get: () =>
        {unreadMessages} = @models.mySession?[0]

      updateUI: ({unreadMessages}) =>
        $(@node).find('.notifyUnread').html unreadMessages


  class QueryProxy # extends EventEmitter2
    constructor: (@node, @collector, Config) ->
      @paths = Config.bind(@)()
      @models = @collector.data

      @collector.onAny (_, {root, path}) =>
        event = "#{root}.#{path}"

        _data = @paths[event]?.get()
        @paths[event]?.updateUI _data if _data?

  return {
    queryProxyConfig
    QueryProxy
  }