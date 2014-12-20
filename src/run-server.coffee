express = require 'express'
exec = require('child_process').exec

module.exports = (options)->
  server = express()
  server.use express.static( './encina-report')
  console.log 'Running a server in port 9993 to show files in ./encina-report directory.'
  if options.browser
    command = 'xdg-open http://localhost:9993'
    child = exec command
  
  server.listen 9993