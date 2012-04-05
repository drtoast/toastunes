class app.AlbumPlaylistView extends app.BaseView
  className: 'album-playlist row'
  template_id: 'album-playlist-template'

  events: ->
    'click .remove': 'remove_album'

  remove_album: (e) ->
    e.preventDefault()
    app.playlist.remove @model
