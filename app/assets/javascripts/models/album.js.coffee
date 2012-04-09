class app.Album extends Backbone.Model
  idAttribute: '_id'
  url: ->
    "/api/v1/albums/#{@get('_id')}"

  thumbnail_url: ->
    if @get('thumbnail')
      "/images/thumbnails/#{@get('library')}/#{@get('thumbnail')}"
    else
      "/images/thumbnail.png"

  cover_url: ->
    if @get('cover')
      "/images/covers/#{@get('library')}/#{@get('cover')}"

  toJSON: =>
    json = super
    _.extend json,
      thumbnail: @thumbnail_url()
      cover: @cover_url()
