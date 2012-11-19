require ['spec/helpers/mock', 'spec/helpers/util'], (mock, {defaultTimeout, hasText}) ->

  describe 'Websites', ->
    beforeEach ->
      mock.services()
      mock.loggedIn 'Owner'
      window.location.hash = '/websites'
      waitsFor hasText('h1', 'Websites'), 'no login prompt', defaultTimeout

    it 'should not display anything "undefined"', ->
      $('#addWebsite').click()

      waitsFor hasText('button.saveButton', 'Save'), 'Did not see edit website form', defaultTimeout
      expect($('input').val()).not.toEqual("undefined")

    it 'should let me add a website', ->

      # add some fields
      # click submit
      # should be on websites listing
      # should see changed fields in row

      waitsFor hasText('button.saveButton', 'Save'), 'Did not see edit website form', defaultTimeout
      $('input.subdomain').val('Baz')
      $('input.contactEmail').val('BazOwner@baz.com')
      $('input.url').val('baz.com')
      $('button.saveButton').click()
      expect($('tr.websiteRow td').text()).toMatch(/baz\.com/)

    it 'should list websites', ->

    it 'should let me edit a website'

    it 'should let me delete a website'

    it 'should display undefined as an empty string'
