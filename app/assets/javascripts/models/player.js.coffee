class app.Player extends Backbone.Model

  initialize: ->
    _.bindAll @, 'play', 'pause', 'next', 'update_remaining_time', 'error'
    @playlist = app.playlist
    @albums = app.albums
    @set
      album_index: 0
      track_index: 0
    @create_audio()

  create_audio: ->
    @audio = new Audio autobuffer:true
    @$audio = $(@audio)
    @$audio.bind 'canplay',      @play
    @$audio.bind 'ended',        @next
    @$audio.bind 'timeupdate',   @update_remaining_time
    @$audio.bind 'error',        @error

  load: (url) ->
    @audio.src = url
    @set state:'buffering'

  toggle: ->
    if @get('state') == 'play' then @pause() else @play()

  play: ->
    @audio.play()
    @set state:'play'

  play_album_track: (album_id, track_id) ->
    album = @albums.get album_id
    @playlist.add album unless @playlist.get album_id
    tracks = album.get('tracks')
    track = _.detect tracks, (track) -> track._id == track_id
    track_index = tracks.indexOf track
    @set
      current_album: album
      track_index: track_index
      current_track: track_index
      remaining_time: '0:00'
    @skip 0

  pause: ->
    @audio.pause()
    @set state:'pause'

  next: ->
    current_album = @get('current_album')
    current_track = @get('current_track')
    tracks = current_album.get('tracks')
    track_index = tracks.indexOf(current_track)
    next_track = tracks[track_index + 1]
    if next_track?
      @play_album_track current_album.id, next_track._id
    else
      album_index = @playlist.detect (album) ->
        album.id == current_album.id
      next_album = @playlist.at(album_index + 1)
      console.log album_index, next_album
      if next_album?
        tracks = next_album.get('tracks')
        @play_album_track next_album.id, tracks[0]._id
      else
        @pause()

  prev: ->
    @skip -1

  skip: (count) ->
    album_index = @get 'album_index'
    album = @playlist.at album_index
    unless album
      @set
        album_index: 0
        track_index: 0
        current_album: null
        state:'pause'
      return
    track_index = @get('track_index') + count
    track = album.get('tracks')[track_index]
    if track
      exp = /\/public\/(.*)$/
      [matched, url] = exp.exec track.location
      console.log 'Player#skip', url
      @load url
      @set
        current_album: album
        track_index: track_index
        current_track: track
        remaining_time: '0:00'
    else
      @set
        album_index: album_index + count
        track_index: 0
      @skip 0


  update_remaining_time: (e) ->
    if @audio.duration
      remaining = parseInt(@audio.duration - @audio.currentTime, 10)
      pos = Math.floor((@audio.currentTime / @audio.duration) * 100)
      mins = Math.floor(remaining/60,10)
      secs = remaining - mins*60
      secs = if secs > 9 then secs else "0#{secs}"
      remaining_time = "#{mins}:#{secs}"
      @set remaining_time: remaining_time

  error: (e) ->
    for propName in e.srcElement.error
      if e.srcElement.error[propName] == e.srcElement.error.code
        console.log propName
        @set error:propName
    @set state:'error'
