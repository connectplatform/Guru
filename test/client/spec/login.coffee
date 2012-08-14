require ['app/server', 'app/pulsar'], (server, pulsar) ->

  hasText = (selector, value) ->
    -> ($(selector).text() is value)

  loginPresent = ->
    title = $('#login-modal h3').text()
    title == 'Login'

  describe 'page', ->
    beforeEach ->

      waitsFor hasText('#login-modal h3', 'Login'), 'no login prompt', 1000

    afterEach ->
      server.cookie 'session', null
      window.location.hash = '/login'

    it 'should show the login prompt', ->
      title = $('#login-modal h3').text()
      expect(title).toMatch('Login')

    describe 'with mocked login', ->
      beforeEach ->
        server.cookie 'session', 'session_foo'
        server.login = (args..., cb) ->
          cb null, {name: 'Bob'}
        server.getMyRole = (args..., cb) ->
          cb null, 'Operator'
        server.getChatStats = (args..., cb) ->
          cb null, {unanswered: 0}
        server.getActiveChats = (args..., cb) ->
          cb null, []

      it 'should log me in', ->
        $('#login-modal input#email').val 'foo@bar.com'
        $('#login-modal input#password').val 'foobar'
        $('#login-modal button.btn-primary').click()

        waitsFor hasText('#dashboard h1', 'Dashboard'), 'Did not see dashboard', 1000

  return name: 'loginSpec'
