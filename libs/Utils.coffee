assert = require('assert')
validUrl = require('valid-url')

module.exports = class Utils

  @clone: (obj) ->
    JSON.parse(JSON.stringify(obj))

  @getAndroidPackagePath: (config) ->
    @validateConfig(config)
    config.android.packageName.replace(/\./g, '/')

  @validateConfig: (config) ->
    assert.equal(typeof(config.name), 'string')
    assert.equal(typeof(config.url), 'string')

    assert.equal(validUrl.isUri(config.url)?, true)
    tmpName = /^[0-9A-Za-z\-\_\ \!\@\#\?\+\.\,]*$/.exec(config.name)
    assert.equal(config.name, tmpName)

    assert.equal(typeof(config.desktop), 'object')
    assert.equal(typeof(config.desktop.fullscreen), 'boolean')
    assert.equal(typeof(config.desktop.width), 'number')
    assert.equal(typeof(config.desktop.height), 'number')

    assert.equal(typeof(config.android), 'object')
    assert.equal(typeof(config.android.fullscreen), 'boolean')
    assert.equal(typeof(config.android.packageName), 'string')
    assert.equal(typeof(config.android.offline), 'boolean')

    assert.equal(config.android.packageName.split('.').length >= 3, true)
    tmpPackageName = config.android.packageName.replace(/\W+\./g)
    assert.equal(config.android.packageName, tmpPackageName)

    assert.equal(typeof(config.ios), 'object')
    assert.equal(typeof(config.ios.fullscreen), 'boolean')

    config

  @replaceVars: (path, returnPath, files, config) ->
    cd path

    for file in files
      sed '-i', /\$\{name\}/g, config.name, file
      sed '-i', /\$\{url\}/g, config.url, file
      sed '-i', /\$\{desktop\.width\}/g, config.desktop.width, file
      sed '-i', /\$\{desktop\.height\}/g, config.desktop.height, file
      sed '-i', /\$\{desktop\.fullscreen\}/g, config.desktop.fullscreen.toString(), file
      sed '-i', /\$\{android\.packageName\}/g, config.android.packageName, file
      sed '-i', /\$\{android\.fullscreen\}/g, config.android.fullscreen.toString(), file
      sed '-i', /\$\{android\.offline\}/g, config.android.offline.toString(), file

    cd returnPath

  @moveDesktopIcon: ->
    if test('-e', 'assets/favicon.png')
      mv('-f', 'assets/favicon.png', 'templates/desktop/favicon.png')

  @moveSrcToPackageFolder: (path, returnPath, files, config) ->
    cd path

    packagePath = "app/src/main/java/#{@getAndroidPackagePath(config)}"
    mkdir('-p', packagePath)

    for file in files
      if test('-e', file)
        mv('-f', file, packagePath)

    cd returnPath

  @checkoutTemplates: ->
    if (exec('git checkout templates/').code != 0)
      echo('Error: Git checkout failed')
      exit(1)
