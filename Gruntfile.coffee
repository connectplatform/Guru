path = require "path"

module.exports = (grunt) ->
  require("matchdep").filterDev("grunt-*").forEach(grunt.loadNpmTasks)

  grunt.config.init {
  # -------------------------------------------
  # configs
  # -------------------------------------------
    now: new Date().getTime()

    client_cfg:
      vendor_dir_name: grunt.file.readJSON(".bowerrc").directory
      tmpl_dir_name: "templates"
      bootstrap_dir_name: "bootstrap"
      vendor_static_dir_name: "vendor_static"

      base_dir: "app/client"

      dist_base_dir: "dist/client"
      dist_js_dir: "<%= client_cfg.dist_base_dir %>/js"
      dist_css_dir: "<%= client_cfg.dist_base_dir %>/css"
      dist_vendor_dir: "<%= client_cfg.dist_base_dir %>/vendor"

      tmp_dir: "<%= client_cfg.base_dir %>/.tmp"
      tmp_js_dir: "<%= client_cfg.tmp_dir %>/js"
      tmp_tmpl_dir: "<%= client_cfg.tmp_dir %>/<%= client_cfg.tmpl_dir_name %>"
      tmp_vendor_dir: "<%= client_cfg.tmp_dir %>/<%= client_cfg.vendor_dir_name %>"
      tmp_vendor_static_dir: "<%= client_cfg.tmp_dir %>/<%= client_cfg.vendor_static_dir_name %>"

      tmp_bootstrap_dir: "<%= client_cfg.tmp_vendor_dir %>/<%= client_cfg.bootstrap_dir_name %>"
      tmp_bootstrap_src_js_dir: "<%= client_cfg.tmp_bootstrap_dir %>/js"
      tmp_bootstrap_src_css_dir: "<%= client_cfg.tmp_bootstrap_dir %>/less"
      tmp_bootstrap_dist_js_dir: "<%= client_cfg.tmp_bootstrap_dir %>/dist/js"
      tmp_bootstrap_dist_js_file: "<%= client_cfg.tmp_bootstrap_dist_js_dir %>/bootstrap.js"
      tmp_bootstrap_dist_css_dir: "<%= client_cfg.tmp_bootstrap_dir %>/dist/css"

      src_js_dir: "<%= client_cfg.base_dir %>/src/js"
      src_css_dir: "<%= client_cfg.base_dir %>/src/css"
      src_vendor_dir: "<%= client_cfg.base_dir %>/<%= client_cfg.vendor_dir_name %>"
      src_vendor_static_dir: "<%= client_cfg.base_dir %>/<%= client_cfg.vendor_static_dir_name %>"
      src_tmpl_dir: "<%= client_cfg.base_dir %>/src/<%= client_cfg.tmpl_dir_name %>"

  # -------------------------------------------
  # tasks
  # -------------------------------------------
    clean:
      client_dist: "<%= client_cfg.dist_base_dir %>",
      client_tmp: "<%= client_cfg.tmp_dir %>"

    copy:
      client_js:
        src: "<%= client_cfg.src_vendor_dir %>/requirejs/require.js"
        dest: "<%= client_cfg.dist_js_dir %>/require.js"

      client_html:
        expand: true
        cwd: "<%= client_cfg.base_dir %>"
        src: "*.html"
        dest: "<%= client_cfg.dist_base_dir %>"

      client_css:
        expand: true
        cwd: "<%= client_cfg.src_css_dir %>"
        src: "**/*"
        dest: "<%= client_cfg.dist_css_dir %>"

      client_img:
        expand: true
        cwd: "<%= client_cfg.base_dir %>/img"
        src: "*"
        dest: "<%= client_cfg.dist_base_dir %>/img"

      client_audio:
        expand: true
        cwd: "<%= client_cfg.base_dir %>/audio"
        src: "*"
        dest: "<%= client_cfg.dist_base_dir %>/audio"

      vendor_tmp:
        expand: true
        cwd: "<%= client_cfg.src_vendor_dir %>"
        src: "**/*"
        dest: "<%= client_cfg.tmp_vendor_dir %>"

      vendor_static_tmp:
        expand: true
        cwd: "<%= client_cfg.src_vendor_static_dir %>"
        src: "**/*"
        dest: "<%= client_cfg.tmp_vendor_static_dir %>"

      vendor_static_dist:
        expand: true
        cwd: "<%= client_cfg.src_vendor_static_dir %>"
        src: "**/*.js"
        dest: "<%= client_cfg.dist_vendor_dir %>"

      bootstrap_dist_css:
        expand: true
        cwd: "<%= client_cfg.tmp_bootstrap_dist_css_dir %>"
        src: "**/*"
        dest: "<%= client_cfg.dist_vendor_dir %>/bootstrap/css"

      bootstrap_dist_assets:
        expand: true
        cwd: "<%= client_cfg.tmp_bootstrap_dir %>/img"
        src: "**/*"
        dest: "<%= client_cfg.dist_vendor_dir %>/bootstrap/img"

      treeview_dist_css:
        src: "<%= client_cfg.src_vendor_dir %>/jquery.treeview/jquery.treeview.css"
        dest: "<%= client_cfg.dist_vendor_dir %>/jquery.treeview/css/jquery.treeview.css"

      treeview_dist_assets:
        expand: true
        cwd: "<%= client_cfg.src_vendor_dir %>/jquery.treeview/images"
        src: "**/*"
        dest: "<%= client_cfg.dist_vendor_dir %>/jquery.treeview/css/images"

    concat:
      bootstrap_js:
        src: [
          "<%= client_cfg.tmp_bootstrap_src_js_dir %>/bootstrap-transition.js"
          "<%= client_cfg.tmp_bootstrap_src_js_dir %>/bootstrap-alert.js"
          "<%= client_cfg.tmp_bootstrap_src_js_dir %>/bootstrap-button.js"
          "<%= client_cfg.tmp_bootstrap_src_js_dir %>/bootstrap-carousel.js"
          "<%= client_cfg.tmp_bootstrap_src_js_dir %>/bootstrap-collapse.js"
          "<%= client_cfg.tmp_bootstrap_src_js_dir %>/bootstrap-dropdown.js"
          "<%= client_cfg.tmp_bootstrap_src_js_dir %>/bootstrap-modal.js"
          "<%= client_cfg.tmp_bootstrap_src_js_dir %>/bootstrap-tooltip.js"
          "<%= client_cfg.tmp_bootstrap_src_js_dir %>/bootstrap-popover.js"
          "<%= client_cfg.tmp_bootstrap_src_js_dir %>/bootstrap-scrollspy.js"
          "<%= client_cfg.tmp_bootstrap_src_js_dir %>/bootstrap-tab.js"
          "<%= client_cfg.tmp_bootstrap_src_js_dir %>/bootstrap-typeahead.js"
        ],
        dest: "<%= client_cfg.tmp_bootstrap_dist_js_file %>"

    recess:
      bootstrap_css:
        options:
          compile: true
        src: "<%= client_cfg.tmp_bootstrap_src_css_dir %>/bootstrap.less"
        dest: "<%= client_cfg.tmp_bootstrap_dist_css_dir %>/bootstrap.css"

      bootstrap_responsive_css:
        options:
          compile: true
        src: "<%= client_cfg.tmp_bootstrap_src_css_dir %>/responsive.less",
        dest: "<%= client_cfg.tmp_bootstrap_dist_css_dir %>/bootstrap_responsive.css"

    coffee:
      client_tmp:
        options:
          bare: true
        expand: true
        cwd: "<%= client_cfg.src_js_dir %>"
        src: "**/*.coffee"
        dest: "<%= client_cfg.tmp_js_dir %>"
        rename: (dest, src) ->
          path.resolve(dest, src.replace(/\.coffee$/, ".js"))

    jade:
      tmpl_tmp:
        options:
          client: true
          namespace: false
          amd: true
          compileDebug: false
        expand: true
        cwd: "<%= client_cfg.src_tmpl_dir %>"
        src: "**/*.jade"
        dest: "<%= client_cfg.tmp_tmpl_dir %>"
        ext: ".js"

    requirejs:
      client:
        options:
          baseUrl: "<%= client_cfg.tmp_js_dir %>"
          name: "index"
          optimize: "none"
          wrap: true
          findNestedDependencies: true
          out: "<%= client_cfg.dist_js_dir %>/app.js"
          paths:
            "app": "."
            "middleware": "policy/middleware"
            "templates": "../<%= client_cfg.tmpl_dir_name %>"
            "vendor/jquery": "../<%= client_cfg.vendor_dir_name %>/jquery/dist/jquery"
            "vendor/async": "../<%= client_cfg.vendor_dir_name %>/async/lib/async"
            "vendor/dermis": "empty:"
            "vendor/pulsar": "empty:"
            "vendor/vein": "empty:"
            "jade": "../<%= client_cfg.vendor_dir_name %>/jade_runtime/index"
          include: [
            "../<%= client_cfg.vendor_dir_name %>/jquery.cookies/index"
            "../<%= client_cfg.vendor_dir_name %>/jwerty/jwerty"
            "../<%= client_cfg.vendor_dir_name %>/noty/js/noty/packaged/jquery.noty.packaged"
            "../<%= client_cfg.vendor_dir_name %>/sugar/release/sugar-full.development"
            "../<%= client_cfg.vendor_dir_name %>/jquery.treeview/jquery.treeview"
            "../<%= client_cfg.vendor_dir_name %>/<%= client_cfg.bootstrap_dir_name %>/dist/js/bootstrap"
          ]

  # TODO: update 'karma' task for new values
    karma:
      client_unit:
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

    mochaTest:
      options:
        reporter: "spec"
        ui: "bdd"
        globals: [
          "app"
          "config"
          "boiler"
          "___eio"
        ]
        require: [
          "coffee-script"
          "should"
          "app/config.coffee"
          "test/server/util/boilerplate.coffee"
        ]
        timeout: 4000
        ignoreLeaks: true
      specs:
        src: "test/server/specs/*"

      billing:
        src: "test/server/unit/billing/*.spec.coffee"
  }

  grunt.registerTask "build_bootstrap", [
    "concat:bootstrap_js"
    "recess:bootstrap_css"
    "recess:bootstrap_responsive_css"
  ]

  grunt.registerTask "client_dist", [
    # clear
    "clean:client_dist",
    "clean:client_tmp",

    # build temp files
    "copy:vendor_tmp",
    "copy:vendor_static_tmp",
    "build_bootstrap",
    "coffee:client_tmp",
    "jade:tmpl_tmp",
    "requirejs:client",

    # copy other
    "copy:client_js",
    "copy:client_html",
    "copy:client_css",
    "copy:client_img",
    "copy:client_audio",
    "copy:bootstrap_dist_css",
    "copy:bootstrap_dist_assets",
    "copy:treeview_dist_css",
    "copy:treeview_dist_assets",
    "copy:vendor_static_dist",

    # clear temp
    "clean:client_tmp"
  ]

  # TODO: update for new values
  grunt.registerTask "client_unit", [
    #    "clean:tmp"
    #    "jade:tmp"
    #    "karma:client_unit"
  ]

  grunt.registerTask "default", [
    "client_dist"
  ]