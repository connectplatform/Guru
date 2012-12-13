require '../../app/config'
{app: {port, pulsarPort, url, baseUrl}} = config

clientConfig = JSON.stringify {port: port, pulsarPort: pulsarPort, url: url, baseUrl: baseUrl}
console.log "define(#{clientConfig});"
