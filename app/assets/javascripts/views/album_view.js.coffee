class app.AlbumView extends Backbone.View
  className: 'album'

  initialize: ->
    @template = $('#album-template').html()

  render: ->
    attrs = @model.toJSON()
    $(@el).html Mustache.render(@template, attrs)
    @
