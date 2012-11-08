require ['spec/helpers/mock', 'spec/helpers/util'], (mock, {defaultTimeout, hasText}) ->

  describe 'Login', ->
    beforeEach ->
      window.location.hash = '/login'
      waitsFor hasText('#login-modal h3', 'Login'), 'no login prompt', defaultTimeout
      mock.services()

    it 'should log me into the dashboard', ->
      $('#login-modal input#email').val 'foo@bar.com'
      $('#login-modal input#password').val 'foobar'
      $('#login-modal button.btn-primary').click()

      waitsFor hasText('#dashboard h1', 'Dashboard'), 'Did not see dashboard', defaultTimeout
