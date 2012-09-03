serverConfig = require '../server/config'
{app: {port, pulsarPort}} = serverConfig

clientConfig = JSON.stringify {port: port, pulsarPort: pulsarPort}
console.log "define(#{clientConfig});"
