(function() {

  define(['templates/imageTemplate'], function(image) {
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
        error: function() {}
      });
    };
  });

}).call(this);
