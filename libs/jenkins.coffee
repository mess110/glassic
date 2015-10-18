#!/usr/bin/env node

assert = require('assert')
require 'shelljs/global'

Utils = require('./Utils.coffee')
config = require('../config.json')

Utils.validateConfig(config)

assert.equal(typeof(config.email), 'string')

exec("echo 'GLASSIC_CONFIG_EMAIL=#{config.email}' >> env.properties")
