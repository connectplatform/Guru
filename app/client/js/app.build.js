({
  appDir: '../', // app/public
  baseUrl: '.', // app/public
  dir: '../../jsbuild', // app/jsbuild
  paths: {
    app: 'js',
    templates: 'templates',
    load: 'js/load',
    helpers: 'js/helpers',
    routes: 'js/routes',
    vendor: 'js/vendor',
    policy: 'js/policy',
    middleware: 'js/policy/middleware',
    dermis: 'js/vendor/dermis'
  },
  modules: [
    {
      name: "js/load/index"
    }
  ]
})
