class app.PlaylistView extends Backbone.View
  className: 'playlist'

  events:
    'click .btn.play': 'toggle'
    'click .btn.prev': 'prev'
    'click .btn.next': 'next'

  initialize: ->
    super
    _.bindAll @, 'render', 'autoplay', 'toggle', 'prev', 'next', 'refresh_play_button'
    @collection = app.playlist
    @collection.bind 'change', @render,     @
    @collection.bind 'add',    @render,     @
    @collection.bind 'add',    @autoplay,   @
    @collection.bind 'remove', @render,     @
    @collection.bind 'reset',  @render,     @
    @player = new app.Player
    @player.bind 'change:state', @refresh_play_button

  autoplay: ->
    if @player.get('status') != 'playing'
      @player.skip 0

  refresh_play_button: ->
    player_state = @player.get('state')
    button_state = switch player_state
      when 'buffering' then null
      when 'play' then 'pause'
      when 'pause' then 'play'
      when 'error' then 'oops'
      else '----'
    return unless button_state
    console.log ".btn.play: #{button_state}"
    @$('.btn.play').text button_state

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
