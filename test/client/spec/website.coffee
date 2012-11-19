require ['spec/helpers/mock', 'spec/helpers/util'], (mock, {defaultTimeout, hasText}) ->

  describe 'Websites', ->
    beforeEach ->
      mock.services()
      mock.loggedIn 'Owner'
      window.location.hash = '/websites'
      waitsFor hasText('h1', 'Websites'), 'no login prompt', defaultTimeout

    it 'should list websites', ->

    it 'should not display anything "undefined"', ->
      $('#addWebsite').click()

      waitsFor hasText('.modal-header h3', 'Website Information'), 'Did not see edit website form', defaultTimeout
      expect($('input').val()).not.toEqual("undefined")

    it 'should let me add a website', ->
      $('#addWebsite').click()

      waitsFor hasText('.modal-header h3', 'Website Information'), 'Did not see edit website form', defaultTimeout
      expect ($ '#website-modal input#url').toExist()

      # add some fields
      # click submit
      # should be on websites listing
      # should see changed fields in row

    it 'should let me edit a website'

    it 'should let me delete a website'

    it 'should display undefined as an empty string'
