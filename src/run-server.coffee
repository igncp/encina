express = require 'express'
exec = require('child_process').exec

module.exports = (options)->
  server = express()
  server.use express.static( './encina-report')
  port = process.env.PORT || 9993
  
  server.get '*', (req, res, next)->
    if req.path isnt '/'
      newPath = '/#' + req.path.substr(1,req.path.length - 1)
      res.redirect(newPath)
    else res.sendFile process.cwd() + '/encina-report/index.html'

  console.log 'Running a server in port ' + port + ' to show files in ./encina-report directory.'
  if options.browser
    command = 'xdg-open http://localhost:' + port
    child = exec command
  server.listen port