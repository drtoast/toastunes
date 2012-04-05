class app.Album extends Backbone.Model
  foo: 'bar'
  url: ->
    "/api/v1/albums/#{@id}"

  toJSON: =>
    json = super
    _.extend json,
      thumbnail: "/images/thumbnails/#{@get('library')}/#{@get('thumbnail')}"
      cover: "/images/covers/#{@get('library')}/#{@get('cover')}"
