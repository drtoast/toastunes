class app.PlaylistView extends Backbone.View
  className: 'playlist'

  events:
    'click .btn.play': 'toggle'
    'click .btn.prev': 'prev'
    'click .btn.next': 'next'

  initialize: ->
    super
    _.bindAll @, 'render', 'autoplay', 'toggle', 'prev', 'next', 'refresh_play_button', 'add_album', 'remove_album'
    @collection.bind 'add',    @add_album,    @
    @collection.bind 'remove', @remove_album, @
    @player = @options.player
    @player.bind 'change:state', @refresh_play_button, @
    @player.bind 'change:current_track', @display_current_track, @
    @player.bind 'change:remaining_time', @display_remaining_time, @

  autoplay: ->
    console.log 'autoplay', @player.get('state')
    if @collection.length == 1 && @player.get('state') != 'play'
      @player.skip 0

  refresh_play_button: ->
    player_state = @player.get('state')
    button_state = switch player_state
      when 'buffering' then null
#      when 'play' then '■'
      when 'pause' then '▶'
      when 'error' then '◽'
      else '----'
    return unless button_state
    console.log ".btn.play: #{button_state}"
    @$('.btn.play').text button_state

  display_remaining_time: ->
    if @player.get('state') == 'play'
      @$('.btn.play').text @player.get('remaining_time')

  display_current_track: ->
    artist_name = @player.get('current_album').get('artist_name')
    song_title = @player.get('current_track').title
    now_playing = "#{artist_name} - #{song_title}"
    console.log now_playing
    document.title = now_playing

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

  add_album: (album) ->
    album_view = new app.AlbumPlaylistView
      model: album
      collection: @collection
    @$el.append album_view.render().el
    @autoplay()

  remove_album: (album) ->
    @player.set
      'album_index': @player.get('album_index') - 1

  render: ->
    console.log "PlaylistView#render: #{@collection.length} albums"
    controls_template = $('#controls-template').html()
    @$el.empty()
    @$el.append Mustache.render(controls_template)
    @collection.each (album) =>
      album_view = new app.AlbumPlaylistView model:album
      @$el.append album_view.render().el
    @
