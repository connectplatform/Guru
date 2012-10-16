require '../../app/config'

config.info 'Test log'
config.warn 'Test log'
config.error 'Test log'
config.clientInfo 'Test log'
config.clientWarn 'Test log'
config.clientError 'Test log'

throw new Error 'Testing error catching'
