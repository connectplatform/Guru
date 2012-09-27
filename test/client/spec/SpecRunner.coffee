define ['jasmine/jasmine-html', 'jasmine/jasmine-jquery', 'spec/helpers/util', 'spec/helpers/mock',

    # spec files
    'spec/login',
    'spec/operatorChat',
    'spec/visitorChat',
    'spec/newChat',
    'spec/dashboard',
    'spec/logout'
  ], (jasmineHtml, jjq, {delay}, mock, login, operatorChat, newChat, dashboard) ->

    $('head').append '<link rel="stylesheet" type="text/css" href="/js/vendor/jasmine-1.2.0/jasmine.css">'

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
