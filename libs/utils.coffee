utils =
  escapeRegExp: (str) ->
    # specials = ['-', '[', ']', '/', '{', '}', '(', ')', '*', '+', '?', '.', '\\', '^', '$', '|']
    str.replace /[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, '\\$&'

  validateConfig: (config) ->
    throw 'name missing' unless config.name?
    throw 'url missing' unless config.url?
    config

  replaceVars: (path, returnPath, files, config) ->
    cd path
    for file in files
      sed '-i', /\$\{name\}/g, config.name, file
      sed '-i', /\$\{url\}/g, config.url, file
      sed '-i', /\$\{desktop.width\}/g, config.desktop.width, file
      sed '-i', /\$\{android.packageName\}/g, config.android.packageName, file
    cd returnPath

module.exports = utils
