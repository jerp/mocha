MochaView = require './mocha-view'

module.exports =
  mochaView: null
  configDefaults:
    specDirectory: './spec/'
    saveAllBeforeTest: true
    filterExtensions: ".coffee, .js"
  activate: (state) ->
    @mochaView = new MochaView(state.mochaViewState)
    atom.workspaceView.on 'core:cancel core:close', (event) =>
      @mochaView?.close()
  deactivate: ->
    if @mochaView
      @mochaView.destroy()
      atom.workspaceView.off 'core:cancel core:close'
  serialize: ->
    mochaViewState: @mochaView?.serialize?()
