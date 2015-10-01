#!/usr/bin/env node

utils = require('./utils.coffee')
config = require('../config.json')
grunt = require('grunt')

console.log '\n\n\n'

console.log 'Validating config.json'.bold
utils.validateConfig(config)
console.log 'Done\n'.green

console.log 'Replacing common variables'.bold

for key in ['name', 'url']
  console.log "Replacing #{key}.."
  utils.replace './templates', key, config[key]

console.log 'Done.'.green

console.log '\n'
console.log 'Android'.bold
console.log 'templates/android/'
console.log 'You need Android Studio to build the application.'

console.log '\n'
console.log 'Linux/Windows/Mac'.bold
console.log 'templates/desktop'
console.log 'Read the README.md in templates/desktop for more info.'
