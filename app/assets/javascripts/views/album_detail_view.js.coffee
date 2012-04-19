class app.AlbumDetailView extends app.BaseView
  className: 'album'
  template_id: 'album-detail-template'

  initialize: ->
    super
    _.bindAll(@, 'update_comments_badge')
    @player = @options.player
    @player.on 'change:current_track', @highlight_current_track, @
    @player.on 'change:remaining_time', @update_time_remaining, @
    @comments_view = new app.AlbumCommentsView
      model: @model
    @comments_view.collection.on 'add', @update_comments_badge, @
    @comments_view.collection.on 'reset', @update_comments_badge, @

  events: ->
    'click .album-cover': 'add_to_playlist'

  update_comments_badge: ->
    count = @comments_view.collection.length
    text = if count == 0 then "Comments" else "Comments <span class=badge>#{count}</span>"
    @$('a[href="#album-comments"]').html text

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
    @update_comments_badge()
    @highlight_current_track()
    @
