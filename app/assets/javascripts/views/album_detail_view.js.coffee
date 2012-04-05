class app.AlbumDetailView extends app.BaseView
  className: 'album'
  template_id: 'album-detail-template'

  events: ->
    'click': 'add_to_playlist'

  add_to_playlist: ->
    app.playlist.push @model