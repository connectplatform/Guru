define ['spec/helpers/mock', 'spec/helpers/util'], (mock, {defaultTimeout, hasText}) ->

  describe 'Account', ->
    beforeEach ->
      mock.services()
      mock.loggedIn 'Owner'
      window.location.hash = '/account'
      waitsFor hasText('#page-header h1', 'Account Details'), "account details didn't load", defaultTimeout

    it 'should load account page', ->
