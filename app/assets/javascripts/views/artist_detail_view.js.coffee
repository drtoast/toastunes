class app.ArtistDetailView extends app.BaseView
  className: 'artist'
  template_id: 'artist-detail-template'

  initialize: ->
    super
    _.bindAll @, 'render'
    albums = app.albums.filter (album) =>
      album.get('artist_id') == @model.get('_id')
    @collection = new app.Albums(albums)
    @collection.bind 'add', @render, @
    @collection.bind 'reset', @render, @
    @collection.fetch
      add: true
      data:
        artist_id: @model.get('_id')

  render: ->
    json = @model.toJSON()
    json.albums = @collection.toJSON()
    $(@el).html @template(json)
    unless @collection.length == 0
      @$('.albums').empty()
      @collection.each (album) =>
        app.albums.add album
        view = new app.AlbumSummaryView
          model: album
          collection: app.playlist
        @$('.albums').append view.render().el
    @