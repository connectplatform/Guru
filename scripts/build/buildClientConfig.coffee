require '../../app/config'
{app: {port, particlePort, url, baseUrl, api}} = config

clientConfig = JSON.stringify {port, particlePort, url, baseUrl, api}
console.log "define(#{clientConfig});"
