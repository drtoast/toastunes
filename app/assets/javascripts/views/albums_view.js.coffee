class app.AlbumsView extends Backbone.View
  className: 'albums'

  initialize: ->
    super
    @collection.bind 'change', @render, @
    @collection.bind 'add',    @render, @
    @collection.bind 'remove', @render, @
    @collection.bind 'reset',  @render, @

  render: (e) ->
    console.log "AlbumsView#render: #{@collection.length} albums"
    @$el.empty()
    @collection.each (album) =>
      album_view = new app.AlbumSummaryView model:album
      @$el.append album_view.render().el
    @
