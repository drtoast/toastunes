class app.AlbumDetailView extends app.BaseView
  className: 'album'
  template_id: 'album-detail-template'

  initialize: ->
    super
    @player = @options.player
    @player.bind 'change:current_track', @highlight_current_track, @
    @player.bind 'change:remaining_time', @update_time_remaining, @
    @comments_view = new app.AlbumCommentsView
      model: @model

  events: ->
    'click .album-cover': 'add_to_playlist'

  add_to_playlist: ->
    app.playlist.push @model

  update_time_remaining: ->
    track = @player.get('current_track')
    title = track.title
    remaining = @player.get('remaining_time')
    text = "#{title} [-#{remaining}]"
    @$(".track[data-track-id=#{track._id}]").text(text)

  highlight_current_track: ->
    if track = @player.get('current_track')
      console.log 'highlight_current_track', track
      @$(".track[data-track-id=#{track._id}]")
        .addClass('playing')
        .siblings()
        .removeClass('playing')

  render_comments: ->
    @$('#album-comments').html @comments_view.render().el

  render: ->
    super
    @render_comments()
    @highlight_current_track()
    @
