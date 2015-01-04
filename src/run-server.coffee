express = require 'express'
exec = require('child_process').exec

module.exports = (options)->
  server = express()
  server.use express.static( './encina-report')
  port = process.env.PORT || 9993
  console.log 'Running a server in port ' + port + ' to show files in ./encina-report directory.'
  if options.browser
    command = 'xdg-open http://localhost:' + port
    child = exec command
  
  server.listen port