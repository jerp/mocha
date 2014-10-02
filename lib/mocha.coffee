MochaView = require './mocha-view'
mochajs = require './mocha'
debugger
module.exports =
  mochaView: null

  activate: (state) ->
    @mochaView = new MochaView(state.mochaViewState)

  deactivate: ->
    @mochaView.destroy()

  serialize: ->
    mochaViewState: @mochaView.serialize()
