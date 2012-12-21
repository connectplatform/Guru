define ["templates/treeviewParentNode", "templates/li", "templates/treeview", "templates/relatedChatLink", "app/config"],
  (treeviewParentNode, li, treeview, relatedChatLink, config) ->
    getType: (obj) -> Object.prototype.toString.call(obj).slice 8, -1
    toTitle: (word) ->
      word[0].toUpperCase() + word.slice(1)

    append: (selector, message) ->
      $(selector).append message

    readableSize: (size) ->
      units = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"]
      i = 0
      while size >= 1024
        size /= 1024
        ++i
      return "#{Math.floor(size.toFixed(1))} #{units[i]}"

    prettySeconds: (secs) ->
      days = Math.floor secs / 86400
      hours = Math.floor (secs % 86400) / 3600
      minutes = Math.floor ((secs % 86400) % 3600) / 60
      seconds = ((secs % 86400) % 3600) % 60
      out = ""
      out += "#{days} days " if days > 0
      out += "#{hours} hours " if hours > 0
      out += "#{minutes} minutes" if minutes > 0
      out += " #{seconds} seconds" if seconds > 0 and days <= 0
      return out

    elapsed: (time) ->
      ms = new Date - new Date time

      hrs = Math.floor(ms / (1000 * 60 * 60))
      remaining = ms % (1000 * 60 * 60)

      min = Math.floor(remaining / (1000 * 60))
      remaining = ms % (1000 * 60)

      sec = Math.floor(remaining / 1000)
      {hours: hrs, minutes: min, seconds: sec}

    elapsedDisplay: (time) ->
      e = @elapsed time
      hours = if hours > 0 then "#{e.hours}h : " else ""
      "#{hours}#{e.minutes}m : #{e.seconds}s"

    autotimer: (selector) ->
      @updating ?= {}
      return if @updating[selector]

      updateCounters = => $(selector).each (_, item) =>
        $(item).html @elapsedDisplay($(item).attr 'started')

      updateCounters()
      id = setInterval updateCounters, 1000
      @updating[selector] = id

    cleartimers: ->
      clearInterval id for sel, id of @updating

    formToHash: (form) ->

      # extract an object from the form
      toObj = (obj, item) ->
        obj[item.name] = item.value
        return obj

      hash = $(form).serializeArray().reduce toObj, {}

      # group any related fields into arrays
      for field in hash.keys()
        m = field.match /([A-z]+)-[0-9]+/
        if m
          arrayName = m[1]
          hash[arrayName] ||= []
          hash[arrayName].push hash[field]
          delete hash[field]

      return hash

    jsonToUl: (json) ->
      self = this

      walkJSON = (node, path) ->
        nodeType = $.type node

        switch nodeType

          when 'array'
            rows = ['<ul>']
            rows.push walkJSON element, path for element in node
            rows.push '</ul>'
            return rows.join ""

          when 'object'
            rows = ['<ul>']
            for k, v of node
              newPath = (if path then "#{path}.#{k}" else k)
              rows.push treeviewParentNode parentName:k, childData: walkJSON v, newPath
            rows.push '</ul>'
            return rows.join ""

          when 'undefined', 'null'
            return ''

          else
            return relatedChatLink {appUrl: config.baseUrl, value: node.toString(), path: path}


      result = walkJSON json
      return result

    getDomain: (url) ->
      return '' unless url
      [proto, _, domain] = url.split("/")
      domain or ''

    random: ->
      digit = -> ((Math.random() * 16) | 0).toString 16
      buffer = []
      for n in [1..16]
        buffer.push digit()

      return buffer.join ''

    loadResource: ({type, file, className}) ->

      # This takes a hash with type: 'js' or 'css', file: 'path/to/file.js'
      # and an optional className: 'dom-element-class', not using $ because lowlevel dom stuff
      if type is 'js'
        fileref = document.createElement 'script'
        fileref.setAttribute 'type', 'text/javascript'
        fileref.setAttribute 'src', file
        fileref.setAttribute 'class', className if className?
      else if type is 'css'
        fileref = document.createElement 'link'
        fileref.setAttribute 'rel', 'stylesheet'
        fileref.setAttribute 'type', 'text/css'
        fileref.setAttribute 'href', file
        fileref.setAttribute 'class', className if className?
      if fileref?
        document.getElementsByTagName('head')[0].appendChild(fileref)
