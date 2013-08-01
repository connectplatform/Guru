require.config
  baseUrl: '.'
  packages: [
    {name: 'app', location: 'js'}
    {name: 'templates', location: 'templates'}
    {name: 'load', location: 'js/load'}
    {name: 'helpers', location: 'js/helpers'}
    {name: 'routes', location: 'js/routes'}
    {name: 'vendor', location: 'js/vendor'}
    {name: 'policy', location: 'js/policy'}
    {name: 'middleware', location: 'js/policy/middleware'}
    {name: 'components', location: 'components'}
  ]

  map: '*':
    {'flight/component': 'js/vendor/flight/lib/component'}

require [
  'components/navBar'
  'vendor/particle'
  'vendor/eventemitter2'
  'load/mock'
],
(navBar, particle, EventEmitter2, mock) ->

  mockStream = (deltas) ->
    (identity, receive, finish) ->
      receive 'manifest', mock.manifest
      receive 'payload', mock.payload

      doWithDelay = (ops, delay = 1000) ->
        [op, rest...] = ops
        return unless op?

        setTimeout (() ->
          console.log "doing a thing with op: #{JSON.stringify op}"
          receive 'delta', {
            root: 'myData'
            timestamp: new Date
            oplist: op
          }
          doWithDelay rest, delay
        ), delay

      doWithDelay deltas if deltas

      finish()

  oplist = []

  collector = new particle.Collector
    identity:
      sessionId: '1111'
    onRegister: mockStream mock.deltas

  navBar.attachTo '#navBar', {
    role: 'Owner'
    appName: 'Guru'
    collector: collector
  }
