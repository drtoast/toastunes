class app.AlbumsView extends Backbone.View
  className: 'albums'

  initialize: ->
    super
    @collection.bind 'change', @render, @
    @collection.bind 'add',    @render, @
    @collection.bind 'remove', @render, @
    @template = $('#albums-template').html()
    @collection.fetch()

  render: ->
    attrs = albums:
      _.map app.albums.toJSON(), (album) ->
        title: album.title
        artist_name: album.artist_name
        thumbnail: app.helpers.thumbnail_path(album)
    console.log "AlbumsView#render: #{app.albums.length} albums"
    $(@el).html Mustache.render(@template, attrs)
    @
