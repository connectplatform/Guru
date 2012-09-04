require
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
  ]
, ['load/main']
