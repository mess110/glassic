sys = require('sys')
exec = require('child_process').exec

replaceCount = 0
commonKeys = ['name', 'url']

escapeRegExp = (str) ->
  # specials = ['-', '[', ']', '/', '{', '}', '(', ')', '*', '+', '?', '.', '\\', '^', '$', '|']
  str.replace /[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, '\\$&'

utils =
  puts: (error, stdout, stderr) ->
    replaceCount += 1
    # sys.puts stdout
    console.log 'Done.' if commonKeys.length == replaceCount
    return

  replace: (folder, key, value) ->
    value = escapeRegExp(value)

    cmd = "find #{folder} -type f -exec sed -i -e 's/${#{key}}/#{value}/g' {} \\;"
    exec cmd, @puts
    return

  validateConfig: (config) ->
    console.log 'Validating config.json'
    throw 'name missing' unless config.name?
    throw 'url missing' unless config.url?
    console.log 'Done\n'
    config

  run: (config) ->
    console.log 'Replacing common variables'
    for key in commonKeys
      @replace './templates', key, config[key]

module.exports = utils
