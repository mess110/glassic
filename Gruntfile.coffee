module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON("package.json")

    shell:
      options:
        stderr: false
      help:
        command: 'cat wiki/Help.md'
      compile:
        command: './node_modules/coffee-script/bin/coffee libs/wrapper.coffee'

    update_submodules:
      default:
        options: {}


  grunt.registerTask 'help', ['shell:help']
  grunt.registerTask 'install', ['update_submodules', 'help']
  grunt.registerTask 'compile', ['shell:compile']

  grunt.registerTask 'default', ['help']

  grunt.loadNpmTasks 'grunt-shell'
  grunt.loadNpmTasks 'grunt-update-submodules'
