require ['app/server', 'spec/helpers/mock'], (server, mock) ->
  console.log 'server:', server
  console.log 'mock:', mock

  hasText = (selector, value) ->
    -> ($(selector).text() is value)

  loginPresent = ->
    title = $('#login-modal h3').text()
    title == 'Login'

  describe 'page', ->
    beforeEach ->
      waitsFor hasText('#login-modal h3', 'Login'), 'no login prompt', 1000

    afterEach ->
      mock.removeCookie()
      window.location.hash = '/login'

    it 'should show the login prompt', ->
      title = $('#login-modal h3').text()
      expect(title).toMatch('Login')

    describe 'with mocked login', ->
      beforeEach ->
        mock.services()
        mock.cookie()

      it 'should log me in', ->
        $('#login-modal input#email').val 'foo@bar.com'
        $('#login-modal input#password').val 'foobar'
        $('#login-modal button.btn-primary').click()

        waitsFor hasText('#dashboard h1', 'Dashboard'), 'Did not see dashboard', 1000
