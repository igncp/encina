exec = require('child_process').exec
path = require 'path'
fs = require 'fs'
csf = require 'coffee-files'

mongoose = require 'mongoose'

generateData = (rootDir)->
  command = 'python ' + __dirname + '/python/examine.py ' + rootDir
  child = exec command, (error, stdout, stderr)->
    if stderr then console.log stderr
    else
      console.log stdout.trim() if stdout.trim()
      copyServerFiles()

copyServerFiles = ->
  fs.createReadStream(__dirname + '/output/index.html')
    .pipe(fs.createWriteStream('encina-report/index.html'));
  csf.glob '*.coffee', __dirname + '/output/coffee/', 'encina-report/js'
  console.log 'Done!'

module.exports = (rootDir, repo)->
  if typeof rootDir is 'string'
    generateData rootDir