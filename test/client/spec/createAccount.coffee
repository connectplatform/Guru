require ['spec/helpers/mock', 'spec/helpers/util'], (mock, {hasText}) ->

  submitForm = (overrides={}) ->
    expect($ 'form#createAccount').toExist()

    defaults =
      email: 'foo@bar.com'
      firstName: 'Bob'
      lastName: 'Smith'
      password: 'foobar'
      passwordConfirm: 'foobar'
    defaults.merge overrides

    for field, value of defaults
      $("form#createAccount input[name=#{field}]").val value

    $('form#createAccount button[type=submit]').click()

  describe 'Create Account', ->
    beforeEach ->
      window.location.hash = '/createAccount'
      waitsFor hasText('.page-header h1', 'Create a new account'), 'no login prompt', 200
      mock.services()
      mock.loggedIn 'Owner'

    it 'should accept valid input', ->
      submitForm()

      waitsFor hasText('#content h1', 'Account Details'), 'Did not see account details.', 200

    it 'should validate email', ->
      submitForm {email: null}

      waitsFor hasText('.notify', 'Please enter a valid Email.'), 'Did not see validation error.', 200
