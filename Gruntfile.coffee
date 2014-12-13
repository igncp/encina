module.exports = (grunt) ->
  grunt.initConfig
    coffee:
      app:
        expand: true
        cwd: './src/output/coffee/'
        src: ['**/*.coffee']
        dest: 'src/output/devel/js/'
        ext: '.coffee.js'
    watch:
      outputDevel:
        options:
          atBegin: true
        files: 'src/output/**/*.coffee'
        tasks: ['coffee']

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  grunt.registerTask 'default', ['watch']