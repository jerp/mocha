{View, BufferedProcess, $$} = require 'atom'

module.exports =
  class MochaView extends View

    @content: ->
      @div =>
        css = 'tool-panel pannel panel-bottom padding native-key-bindings'
        @div class: css, outlet: 'script', tabindex: -1, =>
          @div id: 'mocha', class: 'panel-body padded output', outlet: 'output'

    initialize: (serializeState) ->
      atom.workspaceView.command "mocha:test", => @test()

    # Returns an object that can be retrieved when package is activated
    serialize: ->

    # Tear down any state and detach
    destroy: ->
      @detach()

    close: ->
      # Stop any running process and dismiss window
      @stop()
      @detach() if @hasParent()

    resetView: (title = 'Loading...') ->
      # Display window and load message
      # First run, create view
      atom.workspaceView.prependToBottom this unless @hasParent()
      # Close any existing process and start a new one
      @stop()
      # Get script view ready
      @output.empty()

    saveAll: ->
      return unless atom.config.get('mocha.saveAllBeforeTest')
      atom.project.buffers.forEach (buffer) -> buffer.save() if buffer.isModified() and buffer.file?

    test: ->
      @resetView()
      fs   = require 'fs'
      @saveAll()
      path = require 'path'
      specDir = path.join(atom.project.getPath(), atom.config.get('mocha.specDirectory'))
      testFiles = fs.readdirSync(specDir)
      Mocha = require 'mocha'
      mocha = new Mocha(reporter: Mocha.reporters.HTML)
      window.chai = require 'chai' #quick and dirty
      testFiles.forEach (file) ->
        mocha.addFile path.join(specDir, file)
      try
        mocha.run()
      catch error
        errorstr = error.stack or error.toString()
        @output.append $$ ->
          @pre class: "error", =>
            @raw errorstr

      testFiles.forEach (file) ->
        delete require.cache[path.join(specDir, file)]
