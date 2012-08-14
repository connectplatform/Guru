define ['jasmine/jasmine-html', 'spec/login'], (jasmineHtml, login) ->

  delay = (time, fn) -> setTimeout fn, time

  $('head').append '<link rel="stylesheet" type="text/css" href="/js/ext/jasmine-1.2.0/jasmine.css">'

  jasmineEnv = jasmine.getEnv()
  jasmineEnv.updateInterval = 1000
  htmlReporter = new jasmine.HtmlReporter()
  jasmineEnv.addReporter htmlReporter
  jasmineEnv.specFilter = (spec) ->
    htmlReporter.specFilter spec

  $ ->
    delay 40, ->
      console.log 'login spec:', login
      jasmineEnv.execute()
