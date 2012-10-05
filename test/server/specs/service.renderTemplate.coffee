should = require 'should'

boiler 'Render Template', ->

  it 'should be able to render templates from views folder', (done) ->
    renderer = config.require 'services/templates/renderTemplate'

    text = ['foo', 'bar']
    rendered = renderer 'paragraphs', input: text
    expected = '<p>foo</p><p>bar</p>'
    rendered.should.eql expected

    done()
