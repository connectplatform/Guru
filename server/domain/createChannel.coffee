module.exports = (serviceName, veinServer)->
  unless veinServer.services[serviceName]?
    console.log "adding '#{serviceName}' to vein"
    veinServer.add serviceName, (res, message)->
      data =
        message: message
        username: res.cookie 'username'
      res.publish null, data
