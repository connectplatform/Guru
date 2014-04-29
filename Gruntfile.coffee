path = require "path"

module.exports = (grunt) ->
  require("matchdep").filterDev("grunt-*").forEach(grunt.loadNpmTasks)

  grunt.config.init {
    # -------------------------------------------
    # config
    # -------------------------------------------
    now: new Date().getTime()
    paths: {
      dist: "dist"
      tmp: ".tmp"
      client: {
        src: "app/client"
        dest: "<%= paths.dist %>/client"
      }
      client_js: {
        dir_src: "<%= paths.client.src %>/js"
        dir_tmp: "<%= paths.tmp %>/js"
        dir_dest: "<%= paths.client.dest %>/js"
        src: "<%= paths.client_js.dir_src %>/**/*.coffee"
        js: "<%= paths.client_js.dir_dest %>/app.js"
        js_min: "<%= paths.client_js.dir_dest %>/app.min.js"
      }
      client_tmpl: {
        dir_src: "<%= paths.client.src %>/templates"
        dir_tmp: "<%= paths.tmp %>/templates"
        src: "<%= paths.client_tmpl.dir_src %>/**/*.jade"
      }
    }
    clean: {
      tmp: "<%= paths.tmp %>"
      client: "<%= paths.client.dest %>"
      client_archive: "<%= paths.dist %>/*.tar.gz"
    }
    copy: {
      client_img: {
        expand: true
        cwd: "<%= paths.client.src %>/img"
        src: "*"
        dest: "<%= paths.client.dest %>/img"
      }
      client_css: {
        expand: true
        cwd: "<%= paths.client.src %>/css"
        src: "**"
        dest: "<%= paths.client.dest %>/css"
      }
      client_audio: {
        expand: true
        cwd: "<%= paths.client.src %>/audio"
        src: "*"
        dest: "<%= paths.client.dest %>/audio"
      }
      client_html: {
        expand: true
        cwd: "<%= paths.client.src %>"
        src: "*.html"
        dest: "<%= paths.client.dest %>"
      }
      js_vendor: {
        expand: true
        cwd: "<%= paths.client.src %>/js"
        src: "**/*.js"
        dest: "<%= paths.client_js.dir_dest %>"
      }
      vendor_tmp: {
        expand: true
        cwd: "<%= paths.client.src %>/vendor"
        src: "**/*"
        dest: "<%= paths.tmp %>/vendor"
      }
      vendor: {
        expand: true
        cwd: "<%= paths.client.src %>/vendor"
        src: [
          "jquery/dist/jquery.js"
          "jquery.cookies/index.js"
          "jwerty/jwerty.js"
          "async/lib/async.js"
        ]
        dest: "<%= paths.client.dest %>/vendor"
      }
    }
    compress: {
      options: {
        archive: "tar"
        mode: "tgz"
      }
      client: {
        options: {
          archive: "<%= paths.dist %>/client_<%= now %>.tar.gz"
        }
        src: "<%= paths.client.dest %>/**/*"
      }
    }
    coffee: {
      tmp: {
        options: {
          bare: true
        }
        expand: true
        cwd: "<%= paths.client_js.dir_src %>"
        src: "**/*.coffee"
        dest: "<%= paths.client_js.dir_tmp %>"
        rename: (dest, src) ->
          src = src.replace(/\.coffee$/, ".js")
          path.resolve dest, src

      }
    }
    jade: {
      tmp: {
        options: {
          client: true
          namespace: false
          amd: true
          compileDebug: false
        }
        expand: true
        cwd: "<%= paths.client_tmpl.dir_src %>"
        src: "**/*.jade"
        dest: "<%= paths.client_tmpl.dir_tmp %>"
        ext: ".js"
      }
    }
    uglify: {
      options: {
        compress: true
      }
      client_js: {
        src: "<%= paths.client_js.js %>"
        dest: "<%= paths.client_js.js_min %>"
      }
    }
    requirejs: {
      client: {
        options: {
          optimize: "none"
          mainConfigFile: "<%= paths.client_js.dir_tmp %>/index.js"
          wrap: true
          name: "index"
          out: "<%= paths.client_js.js %>"
        }
      }
    }
    karma: {
      client_unit: {
        options:
          basePath: "."
          frameworks: [
            "jasmine"
            "requirejs"
          ]
          preprocessors:
            '**/*.coffee': ['coffee']
          singleRun: true
          plugins: [
            "karma-jasmine"
            "karma-requirejs"
            "karma-phantomjs-launcher"
            "karma-coffee-preprocessor"
          ]
          browsers: ['PhantomJS']
          files: [
            # vendor - not adapted for require.js
            "app/client/js/vendor/sugar-1.3-custom.min.js"

            # vendor - adapted for require.js
            {pattern: 'app/client/js/vendor/**/*.js', included: false}

            # jade runtime
            {pattern: "app/client/vendor/jade_runtime/index.js", included: false}

            # src
            {pattern: 'app/client/js/**/*.coffee', included: false}

            # compiled templates
            {pattern: '.tmp/templates/**/*.js', included: false}

            # specs
#            {pattern: 'test/client/t/**/*.coffee', included: false}
            {pattern: 'test/client/spec/**/*.coffee', included: false}

            # tests main file for require.js
            "test/client/test-main.coffee"
          ]
      }
    }
  }

  grunt.registerTask "client_unit", [
    "clean:tmp"
    "jade:tmp"
    "karma:client_unit"
  ]

  grunt.registerTask "client_js", [
    "clean:tmp"
    "coffee:tmp"
    "jade:tmp"
    "copy:vendor_tmp"
    "requirejs:client"
    "uglify:client_js"
    "clean:tmp"
  ]

  grunt.registerTask "client_dist", [
    "clean:client"
    "clean:client_archive"
    "client_js"
    "copy:js_vendor"
    "copy:client_img"
    "copy:client_css"
    "copy:client_audio"
    "copy:client_html"
    "copy:vendor"
#    "compress:client"
  ]



  grunt.registerTask "default", [
    "client_dist"
  ]