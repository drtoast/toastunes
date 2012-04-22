class app.Rating extends Backbone.Model
  idAttribute: '_id'
  url: ->
    "/api/v1/ratings"
