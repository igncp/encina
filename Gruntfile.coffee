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
          if env is 'prod' then return currentDir + 'encina-report/js/'
          else return 'src/output/devel/js/'
        )()
        ext: '.coffee.js'
    stylus:
      app:
        files: {}
    watch:
      outputDevel:
        options:
          atBegin: true
        files: 'src/output/**/*.coffee'
        tasks: ['coffee', 'stylus']

  if env is 'prod'
    config.stylus.app.files[currentDir + '/encina-report/css/styles.css'] = \
      __dirname + '/src/output/styl/styles.styl'
  else
    config.stylus.app.files[__dirname + '/src/output/devel/css/styles.css'] = \
      __dirname + '/src/output/styl/styles.styl'

  grunt.initConfig config

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-stylus'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  grunt.registerTask 'compilations', ['coffee', 'stylus']
  grunt.registerTask 'default', ['compilations']