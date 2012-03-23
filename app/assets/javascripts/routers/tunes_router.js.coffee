class app.TunesRouter extends Backbone.Router
  routes:
    '': 'redirectToAlbums'
    'albums': 'albums'
    'albums/:id': 'album'

  initialize: ->
    @view = new app.AppView collection:app.albums
    @view.render()

  albums: ->

  redirectToAlbums: ->
    console.log "redirect"
    Backbone.history.navigate "albums", trigger:true

  album: (id) ->
    model = new app.Album artist:'The Beatles', title:'Abbey Road'
    view = new app.AlbumView model:model
    console.log "rendering"
    $('#stage').append view.render().el
