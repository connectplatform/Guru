require '../../app/config'
{app: {port, particlePort, url, baseUrl, api, name, env}} = config

clientConfig = JSON.stringify {port, particlePort, url, baseUrl, api, name, env}
console.log "define(#{clientConfig});"
