define ["guru/server", "guru/notify", "routes/sidebar", "templates/sidebar"],
  (server, notify, sidebar, sbTemp) ->
    (args, templ) ->
      window.location = '/' unless server.cookie 'login'

      server.ready ->
        server.getMyChats (err, chats) ->
          sidebar {}, sbTemp
          $('#content').html templ chats: [
            id: 'abc'
            visitor:
              name: "Brandon"
              website: 'reddit.com'
            operators: []
            history: [
              {name: "Brandon", timestamp: new Date, message: "Hello!"}
              {name: "John", timestamp: new Date, message: "Hi, how can I help you?"}
              {name: "Brandon", timestamp: new Date, message: "I'm having trouble logging in."}
            ]
          ,
            id: 'bcd'
            visitor:
              name: "Jack"
              website: 'blockbuster.com'
            operators: [{id: 4, name: "Jill"}]
            history: [
              {name: "Jill", timestamp: new Date, message: "Hi, welcome to blockbuster.com!"}
              {name: "Jack", timestamp: new Date, message: "Hi."}
              {name: "Jill", timestamp: new Date, message: "Anything I can help you with?"}
            ]
          ]

          $('#chatTabs').click (e) ->
            e.preventDefault()
            $(this).tab 'show'

          $('#chatTabs a:first').tab 'show'
