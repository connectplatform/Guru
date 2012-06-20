module.exports = (serviceName, veinServer)->
  veinServer.add serviceName, (res, message)->
    res.send {err: "Not Authorized"} unless res.cookie('login') is 'true' and res.cookie('channel') == serviceName
    data =
      message: message
      username: res.cookie 'username'
    err = undefined
    res.publish err, data