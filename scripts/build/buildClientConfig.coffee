require '../../app/config'
{app: {port, pulsarPort, url}} = config

clientConfig = JSON.stringify {port: port, pulsarPort: pulsarPort, url: url}
console.log "define(#{clientConfig});"
