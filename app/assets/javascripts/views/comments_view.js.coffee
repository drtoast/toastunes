class app.CommentsView extends Backbone.View
  className: 'comments'

  initialize: ->
    super
    @collection.bind 'change', @render, @
    @collection.bind 'add',    @render, @
    @collection.bind 'remove', @render, @
    @collection.bind 'reset',  @render, @

  render: (e) ->
    console.log "CommentsView#render: #{@collection.length} comments"
    @$el.html '<h3>Comments</h3>'
    @collection.each (comment) =>
      comment_view = new app.CommentSummaryView model:comment
      @$el.append comment_view.render().el
    @
