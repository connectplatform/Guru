(function() {

  define(['templates/imageTemplate'], function(image) {
    return function(url, selector) {
      var embedImage;
      console.log('entered embedImageIfExists');
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
          return console.log('error getting image');
        },
        complete: function() {
          return console.log('ajax completed');
        }
      });
    };
  });

}).call(this);
