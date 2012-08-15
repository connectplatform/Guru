(function() {

  require({
    baseUrl: ".",
    packages: [
      {
        name: "templates",
        location: "templates"
      }, {
        name: "app",
        location: "js"
      }, {
        name: "routes",
        location: "js/routes"
      }, {
        name: "ext",
        location: "js/ext"
      }, {
        name: "middleware",
        location: "js/middleware"
      }
    ]
  }, ['app/main']);

}).call(this);
