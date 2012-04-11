class app.Album extends Backbone.Model
  idAttribute: '_id'
  url: ->
    "/api/v1/albums/#{@get('_id')}"
