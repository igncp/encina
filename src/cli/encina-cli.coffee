program = require 'commander'
pjson = require '../../package.json'

examine = require './examine'
server = require './run-server'

program
  .version pjson.version

program
  .command 'examine <path>'
  .description 'Analyze the project, creating an html output'
  .action examine

program
  .command 'server'
  .description 'Run a server to display the generated result. Press Ctrl+C to stop.'
  .option '-b, --browser', 'Opens the default browser'
  .action server

program.parse process.argv

unless program.args.length then program.help()