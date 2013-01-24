require ['spec/helpers/mock', 'spec/helpers/util', 'load/server'], (mock, {defaultTimeout, hasText}, server) ->

  describe 'logout', ->
    beforeEach ->
      mock.services()
      mock.loggedIn()
      window.location.hash = '/dashboard'
      mock.renderSidebar()
      waitsFor hasText('#dashboard h1', 'Dashboard'), 'dashboard to load', defaultTimeout

    it 'should log me out when I click logout', ->
      offlineSet = false
      server.logout = (params, cb) ->
        offlineSet = true

      isOffline = -> offlineSet
      window.location.hash = '/logout'
      waitsFor isOffline, "set session to offline", defaultTimeout
