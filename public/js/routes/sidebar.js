// Generated by CoffeeScript 1.3.1
(function() {

  define(["app/server", "app/notify", "app/pulsar", 'templates/badge'], function(server, notify, pulsar, badge) {
    return function(args, templ) {
      var updates;
      $('#sidebar').html(templ());
      updates = pulsar.channel('notify:operators');
      return updates.on('unansweredCount', function(num) {
        var content;
        console.log("" + num + " unanswered chats.");
        content = num > 0 ? badge({
          num: num
        }) : '';
        return $("#notifyUnanswered").html(content);
      });
    };
  });

}).call(this);
