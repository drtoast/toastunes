window.app =
  init: (init_data) ->
    # see views/albums/index.html.haml
    console.log 'app#init'
    @albums =     new app.Albums init_data.albums
    @artists =    new app.Artists init_data.artists
    @comments =   new app.Comments init_data.comments
    @ratings =    new app.Ratings init_data.ratings
    @users =      new app.Users init_data.users
    @user =       new app.User init_data.current_user
    @playlist =   new app.Albums
    @player =     new app.Player
      playlist:   @playlist
      albums:     @albums
    @router =     new app.TunesRouter
      playlist:   @playlist
      player:     @player
      albums:     @albums
      artists:    @artists
      comments:   @comments
      ratings:    @ratings
    Backbone.history.start() # pushState:true
