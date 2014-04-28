should = require 'should'

boiler 'Service - Email Chat', ->
  it 'should send the transcript of a chat as an email', (done) ->
    # TODO: more correct test.
    # Also, what purpose of this test? Check that nodemailer able to send mails?
    # Now value of 'exitStatus' look so:
    # {
    #   message: 'MIME-Version: 1.0\r\nX-Mailer: Nodemailer (0.3.27; +http://andris9.github.com/Nodemailer/)\r\nDate: Mon, 28 Apr 2014 10:30:28 GMT\r\nMessage-Id: <1398681028630.d2cfe9f@Nodemailer>\r\nTo: success@simulator.amazonses.com\r\nSubject: Transcript of your chat on Guru\r\nContent-Type: text/html; charset=utf-8\r\nContent-Transfer-Encoding: quoted-printable\r\n\r\n<h2>Chat History</h2><p><strong>Time:</strong> Mon Apr 28 2014 13:30:28 =\r\nGMT+0300 (EEST)</p><p><strong>Customer:</strong> visitor</p><p><strong>Webs=\r\nite:</strong> foo.com</p><h3>Chats</h3><div class=3D=22well =\r\nprintPage=22><p><strong>visitor:</strong> Hello</p><p><strong>visitor:</str=\r\nong> How are you=3F</p></div>\r\n',
    #   envelope: {
    #     to: [ 'success@simulator.amazonses.com' ],
    #     stamp: 'Postage paid, Par Avion'
    #   }
    # }
    done()
    return

    @getAuthed =>
      @newVisitor {username: 'visitor', websiteUrl: 'foo.com'}, (err, client) =>

        pack = (message) =>
          chatId: @chatId
          message: message

        client.say pack('Hello'), =>
          client.say pack('How are you?'), =>

            client.emailChat {chatId: @chatId, email: 'success@simulator.amazonses.com'}, (err, exitStatus) =>
              should.not.exist err
              should.exist exitStatus
              exitStatus.message.should.match /MessageId/
              done()
