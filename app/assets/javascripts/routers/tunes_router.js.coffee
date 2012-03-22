class app.TunesRouter extends Backbone.Router
  routes:
    '': 'redirectToAlbums'
    'albums': 'albums'
    'albums/:id': 'album'

#  initialize: ->
#    @view = new app.AppView collection: app.Tasks
#    app.Tasks.bind 'change:date', @changeDate, @

  albums: ->
    model = new app.Album artist:'The Beatles', title:'Abbey Road'
    view = new app.AlbumView model:model
    console.log "rendering"
    $('#stage').append view.render().el

  redirectToAlbums: ->
    console.log "redirect"
    Backbone.history.navigate "albums", trigger:true

  album: (id) ->

