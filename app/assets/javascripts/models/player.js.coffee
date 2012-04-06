class app.Player extends Backbone.Model

  initialize: ->
    super
    _.bindAll @, 'play', 'pause', 'next', 'update_position', 'error'
    @playlist = app.playlist
    @set
      album_index: 0
      track_index: 0
    @create_audio()

  create_audio: ->
    @audio = new Audio autobuffer:true
    @$audio = $(@audio)
    @$audio.bind 'canplay',      @play
    @$audio.bind 'ended',        @next
    @$audio.bind 'timeupdate',   @update_position
    @$audio.bind 'error',        @error

  load: (url) ->
    @audio.src = url
    @set state:'buffering'

  toggle: ->
    if @get('state') == 'play' then @pause() else @play()

  play: ->
    @audio.play()
    @set state:'play'

  pause: ->
    @audio.pause()
    @set state:'pause'

  next: ->
    @skip 1

  prev: ->
    @skip -1

  skip: (count) ->
    album_index = @get 'album_index'
    album = @playlist.at album_index
    unless album
      console.log "no album at #{album_index}"
      @set
        album_index: 0
        track_index: 0
        state:'pause'
      return
    track_index = @get 'track_index'
    track_index += count
    track = album.get('tracks')[track_index]
    if track
      exp = /\/public\/(.*)$/
      [matched, url] = exp.exec track.location
      @load url
      console.log 'Player#skip', url
      @set track_index: track_index
    else
      @set
        album_index: album_index + count
        track_index: 0
      @skip 0


  update_position: (e) ->
    if @audio.duration
      remaining = parseInt(@audio.duration - @audio.currentTime, 10)
      pos = Math.floor((@audio.currentTime / @audio.duration) * 100)
      mins = Math.floor(remaining/60,10)
      secs = remaining - mins*60
      remaining_time = ('-' + mins + ':' + (secs > 9 ? secs : '0' + secs))
    @set remaining_time: remaining_time

  error: (e) ->
    for propName in e.srcElement.error
      if e.srcElement.error[propName] == e.srcElement.error.code
        console.log propName
        @set error:propName
    @set state:'error'
