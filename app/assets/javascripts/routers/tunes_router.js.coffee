class app.TunesRouter extends Backbone.Router
  routes:
    '': 'redirectToAlbums'
    'albums': 'albums'
    'albums/:id': 'album'

  initialize: ->
#    @view = new app.AppView collection:app.albums
#    @view.render()
    console.log 'TunesRouter#initialize'
    console.log app.playlist
    @albums_view = new app.AlbumsView collection:app.albums
    @playlist_view = new app.PlaylistView collection:app.playlist
    $('#list').empty().append @albums_view.render().el
    $('#playlist').empty().append @playlist_view.render().el

  albums: ->
    console.log 'TunesRouter#albums'
    app.albums.fetch()

  redirectToAlbums: ->
    console.log "redirect"
    Backbone.history.navigate "albums", trigger:true

  album: (id) ->
    model = new app.Album artist:'The Beatles', title:'Abbey Road'
    view = new app.AlbumView model:model
    console.log "rendering"
    $('#stage').append view.render().el
