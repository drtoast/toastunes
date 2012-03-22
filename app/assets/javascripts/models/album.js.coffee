class app.Album extends Backbone.Model
  foo: 'bar'
  url: ->
    "/api/v1/albums/#{@id}"
