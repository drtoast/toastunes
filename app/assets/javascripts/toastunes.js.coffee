window.app =
  init: ->
    @albums = new app.Albums
    @router = new app.TunesRouter
    Backbone.history.start() # pushState:true

$ ->
  app.init()
