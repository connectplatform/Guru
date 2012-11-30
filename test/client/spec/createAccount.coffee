require ['spec/helpers/mock', 'spec/helpers/util'], (mock, {delay, hasText, doesNotHaveText, defaultTimeout}) ->

  fill = (field, value) ->
    $("form#createAccount input[name=#{field}]").val(value).change()

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
      fill field, value

    $('form#createAccount button[type=submit]').click()

  describe 'Create Account', ->
    beforeEach ->
      mock.services()
      window.location.hash = '/createAccount'
      waitsFor hasText('.page-header h1', 'Create a new account'), 'no login prompt', defaultTimeout
      mock.loggedIn 'Owner'

    it 'should accept valid input', ->
      submitForm()

      waitsFor hasText('#content h1', 'Account Details'), 'Did not see account details.', defaultTimeout

    it 'should validate email', ->
      submitForm {email: null}

      waitsFor hasText('.help-inline', 'Email is required.'), 'Did not see validation error.', defaultTimeout

    it 'should validate confirmation match on password change', ->
      runs -> fill 'passwordConfirm', 'foo'
      waitsFor hasText('.help-inline', 'Password confirmation must match.'), 'Did not see validation error.', defaultTimeout

      runs -> fill 'password', 'foo'
      waitsFor doesNotHaveText('.help-inline:visible', 'Password confirmation must match.'), 'Validation error did not dissapear.', defaultTimeout
