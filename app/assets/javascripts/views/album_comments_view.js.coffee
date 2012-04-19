class app.AlbumCommentsView extends app.BaseView
  className: 'album-comments'
  template_id: 'album-comments-template'

  initialize: ->
    super
    @collection = new app.Comments(@model.comments())
    @collection.bind 'add', @render, @
    @collection.bind 'reset', @render, @
    @collection.fetch
      add: true
      data:
        album_id: @model.get('_id')

  cache_comments: ->
    @collection.each (comment) =>
      app.comments.add comment

  render: ->
    console.log "AlbumCommentsView#render: #{@collection.length} comments"
    @cache_comments()
    $(@el).html @template
      comments: @collection.toJSON()
    @