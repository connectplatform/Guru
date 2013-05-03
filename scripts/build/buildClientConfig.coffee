require '../../app/config'
{app: {port, pulsarPort, url, baseUrl, api, name}} = config

clientConfig = JSON.stringify {port: port, pulsarPort: pulsarPort, url: url, baseUrl: baseUrl, api: api, name: name}
console.log "define(#{clientConfig});"
