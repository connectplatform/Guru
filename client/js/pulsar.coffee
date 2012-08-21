define ["ext/pulsar"], (_) ->
  #TODO change this if pulsar gets updated to play nice with AMD again
  Pulsar.createClient port: 4001
