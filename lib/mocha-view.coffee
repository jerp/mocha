{View} = require 'atom'

module.exports =
class MochaView extends View
  @content: ->
    @div class: 'mocha overlay from-top', =>
      @div "The Mocha package is Alive! It's ALIVE!", class: "message"

  initialize: (serializeState) ->
    atom.workspaceView.command "mocha:toggle", => @toggle()

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()

  toggle: ->
    console.log "MochaView was toggled!"
    if @hasParent()
      @detach()
    else
      atom.workspaceView.append(this)
