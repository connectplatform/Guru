require.config {
  baseUrl: "."

  paths: {
    "app": "."
    "middleware": "policy/middleware"
    "templates": "../templates"
    "jade": "../vendor/jade_runtime/index"
    "dermis": "empty:"
    "pulsar": "empty:"
    "vein": "empty:"
    "async": "https://cdnjs.cloudflare.com/ajax/libs/async/0.7.0/async"
  }
}

define ["load/shim", "load/main"], () ->