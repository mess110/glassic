sys = require('sys')
exec = require('child_process').exec


escapeRegExp = (str) ->
  # specials = ['-', '[', ']', '/', '{', '}', '(', ')', '*', '+', '?', '.', '\\', '^', '$', '|']
  str.replace /[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, '\\$&'

utils =
  puts: (error, stdout, stderr) ->
    sys.puts stdout
    return

  replace: (folder, key, value) ->
    value = escapeRegExp(value)

    cmd = "find #{folder} -type f -exec sed -i -e 's/${#{key}}/#{value}/g' {} \\;"
    exec cmd, @puts
    return

  validateConfig: (config) ->
    throw 'name missing' unless config.name?
    throw 'url missing' unless config.url?

module.exports = utils
