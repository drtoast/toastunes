class app.PlaylistView extends Backbone.View
  className: 'playlist'

  events:
    'click .btn.play': 'toggle'
    'click .btn.prev': 'prev'
    'click .btn.next': 'next'

  initialize: ->
    super
    _.bindAll @, 'render', 'toggle', 'prev', 'next', 'refresh_play_button', 'add_album', 'remove_album'
    @collection.bind 'add',    @add_album,    @
    @collection.bind 'remove', @remove_album, @
    @player = @options.player
    @player.bind 'change:state', @refresh_play_button, @
    @player.bind 'change:current_track', @display_current_track, @
    @player.bind 'change:remaining_time', @display_remaining_time, @

  refresh_play_button: ->
    player_state = @player.get('state')
    button_state = switch player_state
      when 'buffering' then null
#      when 'play' then '■'
      when 'pause' then '<i class="icon-play"></i>'
      when 'error' then '<i class="icon-exclamation-sign"></i>'
      else '----'
    return unless button_state
    @$('.btn.play').html button_state

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
    @player.play() if @player.playlist.length == 1

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
