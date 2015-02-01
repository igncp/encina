express = require 'express'

urlExceptions = [
  '/'
  '/reports-files'
]

exec = require('child_process').exec
fs = require 'fs'

encinaPath = process.cwd() + '/encina-reports/'

dataFiles = fs.readdirSync encinaPath + 'data/'
dataFilesUrls = dataFiles.map (file)-> '/data/' + file
dataFilesNames = dataFiles.map (file)-> file.substr 0, file.length - 5

urlExceptions = urlExceptions.concat dataFilesUrls

module.exports = (options)->
  server = express()
  server.use express.static( './encina-reports')
  port = process.env.PORT || 9993
  
  server.get '*', (req, res, next)->
    if urlExceptions.indexOf(req.path) < 0
      newPath = '/#' + req.path.substr(1,req.path.length - 1)
      res.redirect(newPath)

    else
      if req.path is '/'
        res.sendFile encinaPath + 'index.html'

      else if req.path is '/reports-files'
        res.send dataFilesNames

  console.log 'Running a server in port ' + port + ' using ./encina-reports directory.'
  
  if options.browser
    command = 'xdg-open http://localhost:' + port
    child = exec command
  
  server.listen port