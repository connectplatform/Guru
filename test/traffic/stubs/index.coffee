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
  'load/mock'
  'load/query'
],
(navBar, particle, mock, query) ->

  oplist = []

  collector = new particle.Collector
    identity:
      sessionId: '1111'
    onRegister: mock.mockStream mock.deltas

  queryProxy = new query.QueryProxy collector, query.config

  navBar.attachTo '#navBar', {
    role: 'Owner'
    appName: 'Guru'
    collector: collector
    models: collector.data
    queryProxy: queryProxy
  }
