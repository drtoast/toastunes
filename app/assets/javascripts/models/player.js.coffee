class app.Player extends Backbone.Model

  initialize: ->
    _.bindAll @, 'play', 'pause', 'next', 'track_ended', 'time_update', 'error'
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
    @$audio.bind 'ended',        @track_ended
    @$audio.bind 'timeupdate',   @time_update
    @$audio.bind 'error',        @error

  toggle: ->
    if @get('state') == 'play' then @pause() else @play()

  play: ->
    if @get('current_track')
      @audio.play()
      @set state:'play'
    else
      [album_id, track_id] = @first_track_id()
      if track_id
        app.router.navigate "#albums/#{album_id}/tracks/#{track_id}", trigger:true
      else
        @set state:'pause'

  pause: ->
    return if @get('state') == 'pause'
    @audio.pause()
    @set state:'pause'

  play_album_track: (album_id, track_id) ->
    album = @albums.get album_id
    @playlist.add album unless @playlist.get album_id
    tracks = album.get('tracks')
    track = _.detect tracks, (track) -> track._id == track_id
    track_index = tracks.indexOf track

    regex = /\/public\/(.*)$/
    [matched, url] = regex.exec(track.location) || [null, "/music/#{album.get('library')}/#{track.location}"]
    console.log 'Player#play_album_track', url
    @audio.src = url
    @set
      current_album: album
      current_track: track
      remaining_time: '0:00'
    @play()

  first_track_id: ->
    first_album = @playlist.first()
    first_track = first_album.get('tracks')[0]
    [first_album.id, first_track._id]

  next_track_id: (offset) ->
    current_album = @get('current_album')
    current_track = @get('current_track')
    tracks = current_album.get('tracks')
    track_index = tracks.indexOf(current_track)
    next_track = tracks[track_index + offset]
    if next_track?
      return [current_album.id, next_track._id]
    else
      album_index = @playlist.indexOf current_album
      next_album = @playlist.at(album_index + offset)
      if next_album?
        next_tracks = next_album.get('tracks')
        next_track = if offset == -1 then next_tracks[next_tracks.length - 1] else next_tracks[0]
        return [next_album.id, next_track._id]
      else
        return [null, null]

  track_ended: ->
    @next 1

  next: (offset=1) ->
    [album_id, track_id] = @next_track_id(offset)
    if track_id
      app.router.navigate "#albums/#{album_id}/tracks/#{track_id}", trigger:true
    else
      @pause()

  prev: ->
    @next -1

  time_update: (e) ->
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
