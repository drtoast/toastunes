window.app =
  init: ->
    console.log 'app#init'
    @albums = new app.Albums
    @playlist = new app.Albums
    @router = new app.TunesRouter
    Backbone.history.start() # pushState:true

$ ->
  app.init()
