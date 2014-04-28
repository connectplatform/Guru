module.exports = (grunt) ->
  require("matchdep").filterDev("grunt-*").forEach(grunt.loadNpmTasks)

  grunt.config.init {
    # -------------------------------------------
    # config
    # -------------------------------------------
    now: new Date().getTime()
    paths: {
      dist: "dist"
      client: {
        src: "app/client"
        dest: "<%= paths.dist %>/client"
      }
      client_js: {
        src: "<%= paths.client.src %>/js/**/*.coffee"
        js: "<%= paths.client.dest %>/js/app.js"
        js_min: "<%= paths.client.dest %>/js/app.min.js"
      }
      client_tmpl: {
        src: "<%= paths.client.src %>/templates/**/*.jade"
        js: "<%= paths.client.dest %>/js/tmpl.js"
        js_min: "<%= paths.client.dest %>/js/tmpl.min.js"
      }
    }
    clean: {
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
      client: {
        src: "<%= paths.client_js.src %>"
        dest: "<%= paths.client_js.js %>"
      }
    }
    jade: {
      client: {
        options: {
          client: true
        }
        src: "<%= paths.client_tmpl.src %>"
        dest: "<%= paths.client_tmpl.js %>"
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
      client_tmpl: {
        src: "<%= paths.client_tmpl.js %>"
        dest: "<%= paths.client_tmpl.js_min %>"
      }
    }
  }

  grunt.registerTask "client_dist", [
    "clean:client"
    "clean:client_archive"
    "coffee:client"
    "jade:client"
    "uglify:client_js"
    "uglify:client_tmpl"
    "copy:client_img"
    "copy:client_css"
    "copy:client_audio"
    "copy:client_html"
    "compress:client"
  ]

  grunt.registerTask "default", [
    "client_dist"
  ]