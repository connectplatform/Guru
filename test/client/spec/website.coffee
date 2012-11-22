require ['spec/helpers/mock', 'spec/helpers/util'], (mock, {defaultTimeout, hasText, notExists}) ->

  describe 'Websites', ->
    beforeEach ->
      mock.services()
      mock.findWebsite()
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

    it 'should let me edit a website', ->
      #Click edit for first website row
      $('a.editWebsite').eq(0).click()

      # should be on edit modal
      waitsFor hasText('button.saveButton', 'Save'), 'Did not see edit website form', defaultTimeout

      # add some fields
      $('input.contactEmail').val('BarOwner@bar.com')
      $('input.url').val('bar.com')

      # click submit
      $('button.saveButton').click()

      # should be on websites listing
      waitsFor notExists('button.saveButton:visible'), defaultTimeout

      # should change fields in row
      expect($('tr.websiteRow td').text()).toMatch(/bar\.com/)

    it 'should let me delete a website', ->
      $('a.deleteWebsite').eq(0).click()
      waitsFor hasText('button.deleteButton', 'Delete'), 'Did not see delete confirmation', defaultTimeout
      $('button.deleteButton').click()
      waitsFor notExists('button.deleteButton:visible'), defaultTimeout
      expect($('tr.websiteRow td').text()).not.toMatch(/bar\.com/)
