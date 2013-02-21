require '../../app/config'
{app: {port, pulsarPort, url, baseUrl, api}} = config

clientConfig = JSON.stringify {port: port, pulsarPort: pulsarPort, url: url, baseUrl: baseUrl, api: api}
console.log "define(#{clientConfig});"
