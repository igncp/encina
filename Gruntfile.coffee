module.exports = (grunt) ->
  currentDir = grunt.option 'root_dir' || './'
  env = grunt.option 'env' || 'dev'

  config =
    coffee:
      app:
        expand: true
        cwd: './coffee/'
        src: ['**/*.coffee']
        dest: './js/'
        ext: '.js'
    stylus:
      app:
        files: {'./css/styles.css': './styl/styles.styl'}
    watch:
      outputDevel:
        options:
          atBegin: true
        files: [
          'coffee/**/*.coffee'
          'styl/**/*.styl'
        ]
        tasks: ['coffee', 'stylus']

  grunt.initConfig config

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-stylus'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  grunt.registerTask 'default', ['watch']