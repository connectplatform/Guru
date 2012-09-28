setSessionOnlineStatus = config.require 'services/session/setSessionOnlineStatus'

module.exports = (args, cookies, cb) ->
  setSessionOnlineStatus cookies.session, true, ->
    cb()
