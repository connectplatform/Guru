module.exports = (args, cookies, cb) ->
  [login] = args
  return "expects argument to have field 'email'" unless login.email?
  return "expects argument to have field 'password'" unless login.password?
  cb()
