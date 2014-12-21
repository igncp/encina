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
        files: (->
          obj = {}
          if env is 'prod'
            obj[currentDir + '/encina-report/css/styles.css'] = \
              __dirname + '/src/output/styl/styles.styl'
          else
            obj[__dirname + '/src/output/devel/css/styles.css'] = \
              __dirname + '/src/output/styl/styles.styl'
          obj
        )()
    copy:
      app:
        files: [{
          expand: true
          cwd: __dirname + '/src/output/'
          src: 'index.html'
          dest: if env is 'prod' then currentDir + '/encina-report/' \
            else __dirname + '/src/output/devel/'
        }, {
          expand: true
          cwd: __dirname + '/src/output/components/'
          src: '**'
          dest: if env is 'prod' then  currentDir + '/encina-report/components/' \
            else __dirname + '/src/output/devel/components/'
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
        ]
        tasks: ['compilations']

  grunt.initConfig config

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-stylus'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  grunt.registerTask 'compilations', ['coffee', 'stylus', 'copy']
  grunt.registerTask 'default', ['compilations']