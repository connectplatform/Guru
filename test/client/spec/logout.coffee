require ['spec/helpers/mock', 'spec/helpers/util', 'load/server'], (mock, {hasText}, server) ->

  describe 'logout', ->
    beforeEach ->
      mock.services()
      mock.loggedIn()
      window.location.hash = '/dashboard'
      mock.renderSidebar()
      waitsFor hasText('#dashboard h1', 'Dashboard'), 'dashboard to load', 200

    it 'should log me out when I click logout', ->
      offlineSet = false
      server.setSessionOffline = (args..., cb) ->
        offlineSet = true

      isOffline = -> offlineSet
      window.location.hash = '/logout'
      waitsFor isOffline, "didn't set session to offline", 200

    it 'should log me out when the window unloads', ->
      offlineSet = false
      server.setSessionOffline = (args..., cb) ->
        offlineSet = true

      isOffline = -> offlineSet
      $(window).unload()
      waitsFor isOffline, "didn't set session to offline", 200
