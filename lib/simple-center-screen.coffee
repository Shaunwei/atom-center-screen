module.exports =
  editor: null
  editorElement: null

  activate: () ->
    atom.commands.add 'atom-workspace', 'simple-center-screen:toggle': =>
      @centerScreen()

  isTop: ->
    @getVisibleTop() is 0

  isBottom: ->
    @getVisibleBottom() is @getEditor().getScreenLineCount()

  getEditor: ->
    atom.workspace.getActiveTextEditor()

  getEditorElement: ->
    atom.views.getView(@getEditor())

  getVisibleTop: ->
    @getEditorElement().getFirstVisibleScreenRow()

  getVisibleBottom: ->
    @getEditorElement().getLastVisibleScreenRow()

  getVisibleHeight: ->
     @getVisibleBottom() - @getVisibleTop() + 1

  getVisibleMidRow: ->
    parseInt (@getVisibleBottom() + @getVisibleTop()) / 2

  getFinalTop: ->
    @getEditor().getCursorScreenPosition().row - parseInt(@getVisibleHeight() / 2)

  getFinalBottom: ->
    @getFinalTop() + @getVisibleHeight()

  centerScreen: ->
    cursorPosition = @getEditor().getCursorScreenPosition()
    diff = @getVisibleMidRow() - cursorPosition.row
    # default by atom
    scrolloff = 3
    if diff > 1
      if not @isTop()
        @getEditor().scrollToScreenPosition([@getFinalTop() + scrolloff, 0])
    else if diff < -1
      if not @isBottom()
        @getEditor().scrollToScreenPosition([@getFinalBottom() - scrolloff, 0])
