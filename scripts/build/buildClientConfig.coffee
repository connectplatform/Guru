require '../../app/config'
{app: {port, pulsarPort}} = config

clientConfig = JSON.stringify {port: port, pulsarPort: pulsarPort}
console.log "define(#{clientConfig});"
