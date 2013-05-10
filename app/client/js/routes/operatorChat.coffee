define ["load/server", "load/pulsar", "load/notify", "components/operatorChat"] (server, pulsar, notify, operatorChat) ->

  console.log "route"
  
  operatorChat.attachTo "#content"
