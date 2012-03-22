window.app =
  init: ->
    app.router = new app.TunesRouter
    Backbone.history.start() # pushState:true

$ ->
  app.init()
