class app.Comment extends Backbone.Model
  idAttribute: '_id'
  url: ->
    "/api/v1/comments/#{@id}"
