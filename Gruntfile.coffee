module.exports = (grunt) ->
  currentDir = grunt.option 'root_dir' || './'
  env = grunt.option 'env' || 'dev'

  config =
    coffee:
      app:
        expand: true
        cwd: './src/output/coffee/'
        src: ['**/*.coffee']
        dest: (->
          if env is 'prod' then return currentDir + 'encina-reports/js/'
          else return 'src/output/devel/encina-reports/js/'
        )()
        ext: '.js'
    stylus:
      app:
        files: (->
          obj = {}
          if env is 'prod'
            obj[currentDir + '/encina-reports/css/styles.css'] = \
              __dirname + '/src/output/styl/styles.styl'
          else
            obj[__dirname + '/src/output/devel/encina-reports/css/styles.css'] = \
              __dirname + '/src/output/styl/styles.styl'
          obj
        )()
    copy:
      app:
        files: [{
          expand: true
          cwd: __dirname + '/src/output/'
          src: 'index.html'
          dest: if env is 'prod' then currentDir + '/encina-reports/' \
            else __dirname + '/src/output/devel/encina-reports/'
        }, {
          expand: true
          cwd: __dirname + '/src/output/components/'
          src: '**'
          dest: if env is 'prod' then  currentDir + '/encina-reports/components/' \
            else __dirname + '/src/output/devel/encina-reports/components/'
        }, {
          expand: true
          cwd: __dirname + '/src/output/views/'
          src: '**'
          dest: if env is 'prod' then  currentDir + '/encina-reports/views/' \
            else __dirname + '/src/output/devel/encina-reports/views/'
        }]
    watch: # For devel
      outputDevel:
        options:
          atBegin: true
        files: [
          'src/output/coffee/**/*.coffee'
          'src/output/styl/**/*.styl'
          'src/output/index.html'
          'src/output/components/**/*.html'
          'src/output/views/**/*.html'
        ]
        tasks: ['compilations']

  grunt.initConfig config

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-stylus'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  grunt.registerTask 'compilations', ['coffee', 'stylus', 'copy']
  grunt.registerTask 'default', ['compilations']