#!/usr/bin/env node

utils = require('./utils.coffee')
config = require('../config.json')

console.log '\n\n\n'

console.log 'Validating config.json\n'
utils.validateConfig(config)

console.log 'Replacing common variables\n'

for key in ['name', 'url']
  console.log "Replacing #{key}.."
  utils.replace './templates', key, config[key]

console.log '\nDone.'
