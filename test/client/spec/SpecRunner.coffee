define ['jasmine/jasmine-html', 'jasmine/jasmine-jquery', 'spec/helpers/util', 'spec/helpers/mock',

    # spec files
    'spec/createAccount',
    'spec/dashboard',
    'spec/login',
    'spec/logout',
    'spec/newChat',
    'spec/operatorChat',
    'spec/printChat',
    'spec/visitorChat'

  ], (jasmineHtml, jjq, {delay}, mock) ->

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
