tt.Routers.Application = Backbone.Router.extend
  routes:
    '':         'index'
    'signin':   'signin'
    'signout':  'signout'
    'albums':   'albums'
    'album':    'album'
    'artists':  'artists'
    'genres':   'genres'

  index: ->
    tt.log "router: index"
    # tt.views.application.render()

  albums: ->
    tt.log "router: album"
    album_view = new tt.Views.AlbumIndex
    album_view.render()

  album: ->
    tt.log "router: album_show"
    # find album, then set
    # album_view.model = (some album)
    tt.views.album.render()

