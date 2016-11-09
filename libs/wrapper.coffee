#!/usr/bin/env node

require 'shelljs/global'

Utils = require('./Utils.coffee')
config = require('../config.json')

Utils.validateConfig(config)
Utils.checkoutTemplates()

desktopFiles = ['README.md', 'package.json', 'index.html']
Utils.replaceVars('templates/desktop', '../..', desktopFiles, config)
Utils.moveDesktopIcon()

androidFiles = [
  'README.md'
  'app/build.gradle'
  'app/src/main/AndroidManifest.xml'
  'app/src/main/res/values/strings.xml'
  'app/src/main/res/menu/show_web_view.xml'
  'app/src/main/java/ro/northpole/mind/webview/ShowWebView.java'
]
Utils.replaceVars('templates/android', '../..', androidFiles, config)

javaSrcFiles = [
  'app/src/main/java/ro/northpole/mind/webview/ShowWebView.java'
]
Utils.moveSrcToPackageFolder('templates/android', '../..', javaSrcFiles, config)
Utils.moveAndroidIcons()
Utils.cloneOfflineRepo('templates/android', '../..', config)

ios7Files = [
  'Demo/Classes/ViewController.m'
]
Utils.replaceVars('templates/ios7', '../..', ios7Files, config)
