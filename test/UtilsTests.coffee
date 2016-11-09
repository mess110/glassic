assert = require('assert')

utils = require('../libs/Utils.coffee')
config = require('../config.json')

shouldHaveError = (cfg) ->
  assert.throws (->
    utils.validateConfig(cfg)
  ), Error

describe 'Utils', ->

  describe 'clone', ->

    it 'works', ->
      hash = utils.clone({hello: 1})
      assert.equal(hash.hello, 1)

  describe 'validateConfig', ->

    beforeEach ->
      @c = utils.clone(config)

    it 'is valid', ->
      utils.validateConfig(config)

    it 'requires name', ->
      delete @c.name
      shouldHaveError(@c)

    it 'requires a valid name', ->
      @c.name = {}
      shouldHaveError(@c)

      @c.name = 'asd;'
      shouldHaveError(@c)

      @c.name = 'H3llo?+-_ #World!@'
      utils.validateConfig(@c)

    it 'requires url', ->
      delete @c.url
      shouldHaveError(@c)

    it 'requires a valid url', ->
      @c.url = {}
      shouldHaveError(@c)

      @c.url = 'asd'
      shouldHaveError(@c)

    describe 'desktop', ->

      it 'is a hash', ->
        @c.desktop = 'desktop'
        shouldHaveError(@c)

      it 'is required', ->
        @c.desktop = 'desktop'
        shouldHaveError(@c)

      it 'requires desktop.width', ->
        delete @c.desktop.width
        shouldHaveError(@c)

      it 'requires desktop.width to be a number', ->
        @c.desktop.width = 'string'
        shouldHaveError(@c)

      it 'requires desktop.height', ->
        delete @c.desktop.height
        shouldHaveError(@c)

      it 'requires desktop.height to be a number', ->
        @c.desktop.height = 'string'
        shouldHaveError(@c)

      it 'requires desktop.fullscreen', ->
        delete @c.desktop.fullscreen
        shouldHaveError(@c)

      it 'requires desktop.fullscreen to be boolean', ->
        @c.desktop.fullscreen = 'string'
        shouldHaveError(@c)

      it 'requires desktop.resizable', ->
        delete @c.desktop.resizable
        shouldHaveError(@c)

      it 'requires desktop.fullscreen to be boolean', ->
        @c.desktop.resizable = 'string'
        shouldHaveError(@c)

    describe 'android', ->
      it 'is a hash', ->
        @c.android = 'android'
        shouldHaveError(@c)

      it 'is required', ->
        delete @c.android
        shouldHaveError(@c)

      it 'has android.packageName key', ->
        delete @c.android.packageName
        shouldHaveError(@c)

      it 'requires android.packageName to be a string', ->
        @c.android.packageName = {}
        shouldHaveError(@c)

      it 'requires android.packageName to have minimum 2 dots', ->
        @c.android.packageName = 'asd.asd'
        shouldHaveError(@c)

      it 'has android.windowSoftInputMode key', ->
        delete @c.android.windowSoftInputMode
        shouldHaveError(@c)

      it 'requires android.windowSoftInputMode to be a string', ->
        @c.android.windowSoftInputMode = {}
        shouldHaveError(@c)

      it 'requires android.screenOrientation to be a valid value', ->
        @c.android.windowSoftInputMode = 'foo'
        shouldHaveError(@c)

      it 'has android.screenOrientation key', ->
        delete @c.android.screenOrientation
        shouldHaveError(@c)

      it 'requires android.screenOrientation to be a string', ->
        @c.android.screenOrientation = {}
        shouldHaveError(@c)

      it 'requires android.screenOrientation to be a valid value', ->
        @c.android.screenOrientation = 'foo'
        shouldHaveError(@c)

      # https://docs.oracle.com/javase/specs/jls/se6/html/packages.html#7.7
      describe 'requires android.packageName to be a valid JAVA package path', ->

        it 'allows underscore, alpha numeric and .', ->
          @c.android.packageName = '!asd'
          shouldHaveError(@c)

          @c.android.packageName = 'hello.world.now'
          utils.validateConfig(@c)

        it 'does not contain a keyword'

        it 'does not start with a number'

      it 'requires android.offline', ->
        delete @c.android.offline
        shouldHaveError(@c)

      it 'requires android.offline to be boolean', ->
        @c.android.offline = 'string'
        shouldHaveError(@c)

      it 'requires android.offlineRepo to be string', ->
        @c.android.offline = true
        @c.android.offlineRepo = true
        shouldHaveError(@c)

      it 'requires android.fullscreen', ->
        delete @c.android.fullscreen
        shouldHaveError(@c)

      it 'requires android.fullscreen to be boolean', ->
        @c.android.fullscreen = 'string'
        shouldHaveError(@c)

    describe 'ios', ->

      it 'is a hash', ->
        @c.ios = 'ios'
        shouldHaveError(@c)

      it 'is required', ->
        delete @c.ios
        shouldHaveError(@c)

      it 'requires ios.fullscreen', ->
        delete @c.ios.fullscreen
        shouldHaveError(@c)

      it 'requires ios.fullscreen to be boolean', ->
        @c.ios.fullscreen = 'string'
        shouldHaveError(@c)

  describe 'getAndroidPackagePath', ->

    it 'validates config before converting', ->
      c = utils.clone(config)
      delete c.url
      shouldHaveError(c)

    it 'replaces . with /', ->
      packagePath = utils.getAndroidPackagePath(config)
      assert.equal(packagePath, config.android.packageName.replace(/\./g, '/'))
