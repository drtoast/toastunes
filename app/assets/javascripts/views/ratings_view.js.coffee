class app.RatingsView extends Backbone.View
  className: 'ratings'

  initialize: ->
    super
    @collection.bind 'change', @render, @
    @collection.bind 'add',    @render, @
    @collection.bind 'remove', @render, @
    @collection.bind 'reset',  @render, @

  render: (e) ->
    console.log "RatingsView#render: #{@collection.length} ratings"
    @$el.empty()
    @collection.each (rating) =>
      rating_view = new app.RatingSummaryView model:rating
      @$el.append rating_view.render().el
    @
