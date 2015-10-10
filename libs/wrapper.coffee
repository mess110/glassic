#!/usr/bin/env node

utils = require('./utils.coffee')
config = require('../config.json')

utils.validateConfig(config)
utils.run(config)
