app.helpers =
  thumbnail_path: (album) ->
    "/images/thumbnails/#{album.library}/#{album.thumbnail}"
  cover_path: (album) ->
    "/images/covers/#{album.library}/#{album.cover}"