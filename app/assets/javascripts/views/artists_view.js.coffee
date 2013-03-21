class app.ArtistsView extends Backbone.View
  className: 'artists'

  initialize: ->
    super
    @collection.bind 'change', @render, @
    @collection.bind 'add',    @render, @
    @collection.bind 'remove', @render, @
    @collection.bind 'reset',  @render, @

  render: (e) ->
    console.log "ArtistsView#render: #{@collection.length} artists"
    @$el.html '<h3>Artists</h3>'
    @collection.each (artist) =>
      artist_view = new app.ArtistSummaryView model:artist
      @$el.append artist_view.render().el
    @
