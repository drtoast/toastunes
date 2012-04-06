class app.PlaylistView extends Backbone.View
  className: 'playlist'

  events:
    'click a.button.play': 'toggle'
    'click a.button.prev': 'prev'
    'click a.button.next': 'next'

  initialize: ->
    super
    _.bindAll @, 'render', 'autoplay', 'toggle', 'prev', 'next'
    @collection = app.playlist
    @collection.bind 'change', @render,     @
    @collection.bind 'add',    @render,     @
    @collection.bind 'add',    @autoplay,   @
    @collection.bind 'remove', @render,     @
    @collection.bind 'reset',  @render,     @
    @player = new app.Player

  autoplay: ->
    if @player.get('status') != 'playing'
      @player.skip 0

  toggle: (e) ->
    e.preventDefault() if e?
    @player.toggle()

  prev: (e) ->
    e.preventDefault() if e?
    @player.prev()

  next: (e) ->
    console.log 'next'
    e.preventDefault() if e?
    @player.next()

  render: ->
    console.log "PlaylistView#render: #{@collection.length} albums"
    controls_template = $('#controls-template').html()
    @$el.empty()
    @$el.append Mustache.render(controls_template)
    @collection.each (album) =>
      album_view = new app.AlbumPlaylistView model:album
      @$el.append album_view.render().el
    @
