window.tt =
  Views: {}
  Models: {}
  Collections: {}
  Routers: {}

  views: {}
  debug: true

  init: ->
    @router = new tt.Routers.Application
    @views.application = new tt.Views.Application
    @views.album = new tt.Views.Album
    @playlist = new tt.Collections.Albums
    Backbone.history.start()

  log: (text) ->
    console.log text if tt.debug?

$ ->
  # This hack prevents app from being
  # initialized twice due to sprockets weirdness.
  # Will remove once we sort out the Sprockets thing.
  tt.init() unless tt.views.application

