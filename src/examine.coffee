exec = require('child_process').exec
path = require 'path'

mongoose = require 'mongoose'

generateData = (rootDir)->
  command = 'python ' + __dirname + '/python/examine.py ' + rootDir
  child = exec command, (error, stdout, stderr)->
    if stderr then console.log stderr
    else
      generateOutput()

generateOutput = ->
  command = 'python ' + __dirname + '/python/output.py'
  child = exec command, (error, stdout, stderr)->
    if stderr then console.log stderr
    else
      console.log 'Done!'

module.exports = (rootDir, repo)->
  if typeof rootDir is 'string'
    generateData rootDir