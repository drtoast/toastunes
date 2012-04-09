class app.AlbumPlaylistView extends app.BaseView
  className: 'album-playlist'
  template_id: 'album-playlist-template'

  events: ->
    'click .album-thumbnail': 'select_album'
    'click .remove': 'remove_album'

  select_album: ->
    view = new app.AlbumDetailView model:@model
    $('#album-detail').html view.render().el

  remove_album: (e) ->
    e.preventDefault()
    @collection.remove @model
    @remove()
