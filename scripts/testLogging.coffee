require '../app/config'
logging = config.require 'load/logging'
config.log = logging

config.log.info 'Test log'
config.log.client.info 'Test log'
