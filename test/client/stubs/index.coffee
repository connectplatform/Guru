require
  baseUrl: "."
  packages: [
    {name: "templates", location: "templates"}
    {name: "app", location: "js"}
    {name: "routes", location: "js/routes"}
    {name: "ext", location: "js/ext"}
    {name: "jasmine", location: "js/ext/jasmine-1.2.0"}
    {name: "spec", location: "js/spec"}
  ]
, ['app/main', 'app/pulsar', 'jasmine/jasmine', 'spec/SpecRunner']

