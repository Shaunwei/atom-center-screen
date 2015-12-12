module.exports =
  editor: null
  editorElement: null

  activate: () ->
    @editor = atom.workspace.getActiveTextEditor()
    @editorElement = atom.views.getView(@editor)
    atom.commands.add 'atom-workspace', 'simple-center-screen:toggle': =>
      @centerScreen()

  isTop: ->
    @getVisibleTop() is 0

  isBottom: ->
    @getVisibleBottom() is @editor.getScreenLineCount()

  getVisibleTop: ->
    @editorElement.getFirstVisibleScreenRow()

  getVisibleBottom: ->
    @editorElement.getLastVisibleScreenRow()

  getVisibleHeight: ->
     @getVisibleBottom() - @getVisibleTop() + 1

  getVisibleMidRow: ->
    parseInt (@getVisibleBottom() + @getVisibleTop()) / 2

  getFinalTop: ->
    @editor.getCursorScreenPosition().row - parseInt(@getVisibleHeight() / 2)

  getFinalBottom: ->
    @getFinalTop() + @getVisibleHeight()

  centerScreen: ->
    cursorPosition = @editor.getCursorScreenPosition()
    diff = @getVisibleMidRow() - cursorPosition.row
    # default by atom
    scrolloff = 3
    if diff > 1
      if not @isTop()
        @editor.scrollToScreenPosition([@getFinalTop() + scrolloff, 0])
    else if diff < -1
      if not @isBottom()
        @editor.scrollToScreenPosition([@getFinalBottom() - scrolloff, 0])
