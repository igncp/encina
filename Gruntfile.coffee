module.exports = (grunt) ->
  currentDir = grunt.option 'root_dir' || './'
  env = grunt.option 'env' || 'dev'

  config =
    coffee:
      app:
        expand: true
        cwd: './src/display/coffee/'
        src: ['**/*.coffee']
        dest: (->
          if env is 'prod' then return currentDir + 'encina-reports/js/'
          else return 'src/display/devel/encina-reports/js/'
        )()
        ext: '.js'

    stylus:
      app:
        files: (->
          obj = {}
          if env is 'prod'
            obj[currentDir + '/encina-reports/css/styles.css'] = \
              __dirname + '/src/display/styl/styles.styl'
          else
            obj[__dirname + '/src/display/devel/encina-reports/css/styles.css'] = \
              __dirname + '/src/display/styl/styles.styl'
          obj
        )()

    copy:
      app:
        files: [{
          expand: true
          cwd: __dirname + '/src/display/'
          src: 'index.html'
          dest: if env is 'prod' then currentDir + '/encina-reports/' \
            else __dirname + '/src/display/devel/encina-reports/'
        }, {
          expand: true
          cwd: __dirname + '/src/display/components/'
          src: '**'
          dest: if env is 'prod' then  currentDir + '/encina-reports/components/' \
            else __dirname + '/src/display/devel/encina-reports/components/'
        }, {
          expand: true
          cwd: __dirname + '/src/display/views/'
          src: '**'
          dest: if env is 'prod' then  currentDir + '/encina-reports/views/' \
            else __dirname + '/src/display/devel/encina-reports/views/'
        }]

    watch: # For devel
      displayDevel:
        options:
          atBegin: true
        files: [
          'src/display/coffee/**/*.coffee'
          'src/display/styl/**/*.styl'
          'src/display/index.html'
          'src/display/components/**/*.html'
          'src/display/views/**/*.html'
        ]
        tasks: ['compilations']

    # Dev only
    bump:
      options:
        files: ['package.json'],
        updateConfigs: [],
        commit: true,
        commitMessage: 'Release v%VERSION%',
        commitFiles: ['.'],
        createTag: true,
        tagName: 'v%VERSION%',
        tagMessage: 'Version %VERSION%',
        push: true,
        pushTo: 'origin',
        gitDescribeOptions: '--tags --always --abbrev=1 --dirty=-d',
        globalReplace: false

    groc:
      files:
        'src/**/*.coffee'
      options:
        out: 'untracked-docs/groc'

    publish:
      main:
        src: '.'


  grunt.initConfig config

  grunt.loadNpmTasks 'grunt-bump'
  grunt.loadNpmTasks 'grunt-groc'
  grunt.loadNpmTasks 'grunt-publish'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-stylus'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  grunt.registerTask 'compilations', ['coffee', 'stylus', 'copy']
  grunt.registerTask 'default', ['compilations']
  grunt.registerTask 'release', ['groc', 'bump', 'publish']