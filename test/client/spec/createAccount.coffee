require ['spec/helpers/mock', 'spec/helpers/util'], (mock, {hasText}) ->

  describe 'Create Chat', ->
    beforeEach ->
      window.location.hash = '/createAccount'
      waitsFor hasText('.page-header h1', 'Create a new account'), 'no login prompt', 200
      mock.services()

    it 'should display expected fields', ->
      expect($ 'form#createAccount').toExist()

    #it 'should log me into the dashboard', ->
      #$('#login-modal input#email').val 'foo@bar.com'
      #$('#login-modal input#password').val 'foobar'
      #$('#login-modal button.btn-primary').click()

      #waitsFor hasText('#dashboard h1', 'Dashboard'), 'Did not see dashboard', 200

