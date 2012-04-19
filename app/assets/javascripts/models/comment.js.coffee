class app.Comment extends Backbone.Model
  idAttribute: '_id'
  url: ->
    "/api/v1/comments/#{@id}"

  initialize: ->
    super
    app.albums.add @get('album')
