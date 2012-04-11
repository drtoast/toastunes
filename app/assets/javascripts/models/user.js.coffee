class app.User extends Backbone.Model
  idAttribute: '_id'
  url: ->
    "/api/v1/users/#{@id}"
