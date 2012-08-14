define ['jasmine/jasmine-html', 'jasmine/jasmine-jquery', 'spec/helpers/util', 'spec/helpers/mock', 'spec/login', 'spec/operatorChat'],
  (jasmineHtml, jjq, {delay}, mock, login, operatorChat) ->

    $('head').append '<link rel="stylesheet" type="text/css" href="/js/ext/jasmine-1.2.0/jasmine.css">'

    mock.services()

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
