class app.Album extends Backbone.Model
  idAttribute: '_id'
  url: ->
    "/api/v1/albums/#{@get('_id')}"

  comments: ->
    @association 'comments'

  ratings: ->
    @association 'ratings'

  association: (name) ->
    app[name].filter (model) =>
      model.get('album_id') == @get('_id')
