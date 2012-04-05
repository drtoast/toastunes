class app.PlaylistView extends Backbone.View
  className: 'playlist'

  initialize: ->
    super
    @collection.bind 'change', @render, @
    @collection.bind 'add',    @render, @
    @collection.bind 'remove', @render, @
    @collection.bind 'reset',  @render, @

  render: (e) ->
    console.log "PlaylistView#render: #{@collection.length} albums"
    @$el.empty()
    @collection.each (album) =>
      album_view = new app.AlbumPlaylistView model:album
      @$el.append album_view.render().el
    @
