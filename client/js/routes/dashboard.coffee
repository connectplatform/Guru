define ["guru/server", "guru/notify", "routes/sidebar", "templates/sidebar", "guru/util"], (server, notify, sidebar, sideTemp, util) ->
  (args, templ) ->

    sidebar {}, sideTemp
    $('#content').html templ chats: [
        id: 'abc123'
        visitor: 'Bob'
        operator: 'Frank S'
        started: new Date()
        website: 'google.com'
        department: 'catering'
      ,
        id: 'bcf482'
        visitor: 'Chris'
        operator: 'Sally P'
        started: new Date()
        website: 'reddit.com'
        department: 'clowns'
    ]
    util.autotimer '.counter'
