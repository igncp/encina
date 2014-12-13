program = require 'commander'

examine = require './examine'
server = require './run-server'

program
  .option '-f, --file', 'Project file. Default to .'
  .option '-g, --github', 'Github repository. Default to false.'

program
  .command 'examine'
  .description 'Analyze the project, creating an html output'
  .action examine

program
  .command 'server'
  .description 'Run a server to display the generated html output. Press Ctrl+C to stop.'
  .action server

program.parse process.argv

unless program.args.length then program.help()