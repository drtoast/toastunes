class app.AppView extends Backbone.View

  el: '#stage'

  initialize: (options) ->
    @collection.bind 'reset', @render, @
    @subviews = [
      new app.AlbumsView collection: @collection
    ]

  render: ->
    console.log "AppView#render"
    $(@el).empty()
    $(@el).append subview.render().el for subview in @subviews
    @