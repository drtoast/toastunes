window.app =
  init: (init_data) ->
    # see views/albums/index.html.haml
    console.log 'app#init'
    @albums =     new app.Albums init_data.albums
    @artists =    new app.Artists init_data.artists
    @playlist =   new app.Albums
    @player =     new app.Player
      playlist:   @playlist
      albums:     @albums
    @router =     new app.TunesRouter
      playlist:   @playlist
      player:     @player
      albums:     @albums
      artists:    @artists
    Backbone.history.start() # pushState:true
