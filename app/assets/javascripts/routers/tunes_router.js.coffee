class app.TunesRouter extends Backbone.Router
  routes:
    '': 'redirectToAlbums'
    'albums': 'albums'
    'albums/:id': 'album'
    'albums/:album_id/tracks/:track_id': 'album'
    'artists': 'artists'
    'artists/:id': 'artist'

  initialize: (options) ->
    console.log 'TunesRouter#initialize'
    super
    @options =    options
    @playlist =   @options.playlist
    @player =     @options.player
    @artists =    @options.artists
    @albums =     @options.albums
    @playlist_view = new app.PlaylistView
      collection:  @playlist
      player:      @player
    $('#playlist').empty().append @playlist_view.render().el

  albums: ->
    console.log 'TunesRouter#albums'
    @render_albums_list()

  album: (album_id, track_id) ->
    model = @albums.get album_id
    console.log 'TunesRouter#album', model
    @detail_view = new app.AlbumDetailView
      model: model
      player: @player
    @render_albums_list() unless @list_view?
    $('#detail').html @detail_view.render().el
    if track_id?
      @player.play_album_track album_id, track_id

  artists: ->
    console.log 'TunesRouter#artists'
    @render_artists_list()

  artist: (id) ->
    model = @artists.get id
    console.log 'TunesRouter#artist', model
    @detail_view = new app.ArtistDetailView
      model: model
    @render_artists_list() unless @list_view?
    $('#detail').html @detail_view.render().el

  render_artists_list: ->
    @list_view = new app.ArtistsView
      collection: @artists
    $('#list').empty().append @list_view.render().el

  render_albums_list: ->
    @list_view = new app.AlbumsView
      collection: @albums
    $('#list').empty().append @list_view.render().el

  redirectToAlbums: ->
    Backbone.history.navigate "albums", trigger:true
