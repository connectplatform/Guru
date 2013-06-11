require '../../app/config'
{app: {port, particlePort, url, baseUrl, api, name}} = config

clientConfig = JSON.stringify {port, particlePort, url, baseUrl, api, name}
console.log "define(#{clientConfig});"
