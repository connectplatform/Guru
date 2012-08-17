define ['jasmine/jasmine-html', 'jasmine/jasmine-jquery', 'spec/helpers/util', 'spec/helpers/mock',

    # spec files
    'spec/login',
    'spec/operatorChat',
    'spec/newChat'
  ], (jasmineHtml, jjq, {delay}, mock, login, operatorChat, newChat) ->

    $('head').append '<link rel="stylesheet" type="text/css" href="/js/ext/jasmine-1.2.0/jasmine.css">'

    window.location.hash = '/test'
    mock.services()

    jasmineEnv = jasmine.getEnv()
    jasmineEnv.updateInterval = 1000
    htmlReporter = new jasmine.HtmlReporter()
    jasmineEnv.addReporter htmlReporter
    jasmineEnv.specFilter = (spec) ->
      htmlReporter.specFilter spec

    $ ->
      delay 100, -> jasmineEnv.execute()
