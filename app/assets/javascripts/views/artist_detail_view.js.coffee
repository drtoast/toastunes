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

  render: ->
    if @model?
      json = @model.toJSON()
      json.albums = @collection.toJSON()
      $(@el).html @template(json)
      @collection.each (album) =>
        view = new app.AlbumSummaryView
          model: album
          collection: app.playlist
        @$('.albums').append view.render().el
#          @$('.albums').append('see artist_detail_view.js.coffee')
    @