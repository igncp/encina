express = require 'express'

module.exports = ->
  server = express()
  server.use express.static( './encina-report')
  console.log 'Running a server in port 9993 to show files in ./encina-report directory.'
  server.listen 9993