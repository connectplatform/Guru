(function() {

  define(['templates/imageTemplate', 'load/server'], function(image, server) {
    return function(url, selector) {
      var embedImage;
      embedImage = function() {
        return $(selector).html(image({
          source: url
        }));
      };
      return $.ajax({
        type: 'GET',
        async: true,
        url: url,
        success: embedImage,
        error: function() {
          return server.log('Error getting image in embedImageIfExists', {
            severity: 'info',
            imageUrl: url
          });
        }
      });
    };
  });

}).call(this);
