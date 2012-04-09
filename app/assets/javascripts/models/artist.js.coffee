class app.Artist extends Backbone.Model
  idAttribute: '_id'
  url: ->
    "/api/v1/artists/#{@id}"
