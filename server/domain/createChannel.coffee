module.exports = (serviceName, veinServer)->
  unless veinServer.services[serviceName]?
    veinServer.add serviceName, (res, message)->
      data =
        message: message
        username: res.cookie 'username'
      res.publish null, data
