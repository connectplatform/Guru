module.exports = ->
  process.env.GURU_PULSAR_PORT = 'DISABLED'
  config.require('load/initServices')()
  initStoic = config.require 'load/initStoic'
  initStoic ->
    clear = config.require 'services/clearOldChats'
    clear (err) ->
      console.log "#{new Date} - clear chats running"
      console.log err if err?
      process.exit()
