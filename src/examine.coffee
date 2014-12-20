exec = require('child_process').exec
path = require 'path'
fs = require 'fs'
grunt = require 'grunt'

generateData = (rootDir)->
  command = 'python ' + __dirname + '/python/examine.py ' + rootDir
  child = exec command, (error, stdout, stderr)->
    if stderr then console.log stdout + '\n' + stderr
    else
      console.log stdout.trim() if stdout.trim()
      copyServerFiles()

copyServerFiles = ->
  fs.createReadStream(__dirname + '/output/index.html')
    .pipe(fs.createWriteStream('encina-report/index.html'));
  runGrunt()

runGrunt = ->
  command = 'grunt compilations --gruntfile ' + __dirname + '/../Gruntfile.coffee ' + \
    ' --root_dir="' + process.cwd() + '/" --env=prod'
  child = exec command, (error, stdout, stderr)->
    if stderr then console.log stderr
    else
      console.log 'Done!'

module.exports = (rootDir)->
  if typeof rootDir is 'string'
    generateData rootDir