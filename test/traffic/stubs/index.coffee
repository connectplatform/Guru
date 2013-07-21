require.config
  baseUrl: "."
  packages: [
    {name: "app", location: "js"}
    {name: "templates", location: "templates"}
    {name: "load", location: "js/load"}
    {name: "helpers", location: "js/helpers"}
    {name: "routes", location: "js/routes"}
    {name: "vendor", location: "js/vendor"}
    {name: "policy", location: "js/policy"}
    {name: "middleware", location: "js/policy/middleware"}
    {name: "components", location: "components"}
  ]

  map: "*":
    {"flight/component": "js/vendor/flight/lib/component"}

require ['components/navBar'], (navBar) ->
  navBar.attachTo '#navBar', {
    role: 'MyRole'
    appName: 'MyApp'
    models: data: mySession: [username: 'MyUsername']
  }
