should = require 'should'

boiler 'Render Template', ->

  it 'should be able to render templates from views folder', (done) ->
    renderer = config.services['templates/renderTemplate']

    text = ['foo', 'bar']
    rendered = renderer {template: 'paragraphs', options: {input: text}}
    expected = '<p>foo</p><p>bar</p>'
    rendered.should.eql expected

    done()
