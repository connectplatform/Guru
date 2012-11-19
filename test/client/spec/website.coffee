require ['spec/helpers/mock', 'spec/helpers/util'], (mock, {defaultTimeout, hasText, notExists}) ->

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
      waitsFor hasText('button.saveButton', 'Save'), 'Did not see edit website form', defaultTimeout

      # add some fields
      $('input.subdomain').val('Baz')
      $('input.contactEmail').val('BazOwner@baz.com')
      $('input.url').val('baz.com')

      # click submit
      $('button.saveButton').click()

      # should be on websites listing
      waitsFor notExists('button.saveButton:visible'), defaultTimeout

      # should see changed fields in row
      expect($('tr.websiteRow td').text()).toMatch(/baz\.com/)

    it 'should list websites', ->
      expect($('tr.websiteRow td').text()).toMatch(/baz\.com/)

    it 'should let me edit a website'

    it 'should let me delete a website'

    it 'should display undefined as an empty string'
