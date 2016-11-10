#!/usr/bin/env coffee

server = require('../../../../../src/server/server.coffee') # for dev
# server = require('../../bower_components/coffee-engine/src/server/server.coffee')

config =
  pod:
    id: server.Utils.guid()
    dirname: __dirname
    version: 1
    port: 1337
  gameServer:
    ticksPerSecond: 50
    ioMethods: ['position', 'rotateHead', 'shoot']

class GameServer extends server.GameServer
  position: (socket, data) ->
    pod.broadcast('position', data)

  rotateHead: (socket, data) ->
    pod.broadcast('rotateHead', data)

  shoot: (socket, data) ->
    pod.broadcast('shoot', data)

  # disconnect: (socket) ->

gameServer = new GameServer(config.gameServer)
pod = new server.Pod(config.pod, gameServer)
pod.listen()
